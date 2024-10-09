{
  flake,
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.camms.services.arrs;
  path = "${cfg.statePath}";
  user = "media";
  group = "media";
in
with lib;
with flake.lib;
{
  options.camms.services.arrs = {
    enable = mkEnableOption "arrs stack";
    statePath = mkOption {
      type = types.str;
      default = "/media/arrs";
      description = "The location of the mounts and media files";
    };
  };

  config = mkIf cfg.enable {
    users.users.${user} = {
      isSystemUser = true;
      uid = 10000;
      inherit group;
    };
    users.groups.${group} = {
      gid = 10000;
      members = [ config.camms.variables.username ];
    };

    sops.secrets =
      let
        file = {
          owner = config.users.users.${user}.name;
          group = config.users.users.${user}.group;
          sopsFile = "${flake}/secrets/arrs.yaml";
        };
      in
      mkIf config.camms.sops.enable {
        "media/riven.env" = file;
        "media/zurg-config.yml" = file;
      };

    virtualisation = {
      podman = {
        enable = true;
        autoPrune.enable = true;
        dockerCompat = true;
        defaultNetwork.settings = {
          dns_enabled = true;
        };
      };
      oci-containers = {
        backend = "podman";
        containers = {
          "rclone" = {
            image = "rclone/rclone:latest";
            volumes = [
              "/var/lib/zurg/rclone.conf:/config/rclone/rclone.conf:rw"
              "${path}:/mnt:rw"
              "${path}/remote/realdebrid:/data:rw,rshared"
            ];
            cmd = [
              "mount"
              "zurg:"
              "/data"
              "--allow-non-empty"
              "--allow-other"
              "--umask=002"
              "--dir-cache-time"
              "10s"
            ];
            dependsOn = [ "zurg" ];
            log-driver = "journald";
            extraOptions = [
              "--cap-add=SYS_ADMIN"
              "--device=/dev/fuse:/dev/fuse:rwm"
              "--security-opt=apparmor:unconfined"
            ];
          };
          "riven" = {
            image = "spoked/riven:latest";
            environment = {
              "PUID" = "${builtins.toString config.users.users.${user}.uid}";
              "PGID" = "${builtins.toString config.users.groups.${group}.gid}";
              "RIVEN_FORCE_ENV" = "true";
              "RIVEN_SYMLINK_RCLONE_PATH" = "${path}/remote/realdebrid/torrents";
              "RIVEN_SYMLINK_LIBRARY_PATH" = "${path}/jellyfin";
              "RIVEN_DATABASE_HOST" = "postgresql+psycopg2://postgres:postgres@riven-db/riven";
            };
            environmentFiles = mkIf config.camms.sops.enable [ config.sops.secrets."media/riven.env".path ];
            volumes = [
              "/var/lib/riven/data:/riven/data:rw"
              "${path}:${path}:rw"
            ];
            dependsOn = [
              "riven-db"
            ];
            log-driver = "journald";
            extraOptions = [
              "--health-cmd=curl -s http://localhost:8080 >/dev/null || exit 1"
              "--health-interval=30s"
              "--health-retries=10"
              "--health-timeout=10s"
            ];
          };
          "riven-db" = {
            image = "postgres:16.3-alpine3.20";
            environment = {
              "PGDATA" = "/var/lib/postgresql/data/pgdata";
              "POSTGRES_DB" = "riven";
              "POSTGRES_PASSWORD" = "postgres";
              "POSTGRES_USER" = "postgres";
            };
            volumes = [
              "/var/lib/riven/riven-db:/var/lib/postgresql/data/pgdata:rw"
            ];
            log-driver = "journald";
            extraOptions = [
              "--health-cmd=pg_isready -U postgres"
              "--health-interval=10s"
              "--health-retries=5"
              "--health-timeout=5s"
            ];
          };
          "riven-frontend" = {
            image = "spoked/riven-frontend:latest";
            environment = {
              "BACKEND_URL" = "http://riven:8080";
              "DATABASE_URL" = "postgres://postgres:postgres@riven-db/riven";
              "DIALECT" = "postgres";
              "ORIGIN" = "http://localhost:3000";
            };
            ports = [
              "3000:3000/tcp"
            ];
            dependsOn = [
              "riven"
            ];
            log-driver = "journald";
          };
          "zurg" = {
            image = "ghcr.io/debridmediamanager/zurg-testing:v0.9.3-final";
            volumes = [
              "${config.sops.secrets."media/zurg-config.yml".path}:/app/config.yml:rw"
              "/var/lib/zurg/data:/app/data:rw"
            ];
            log-driver = "journald";
            extraOptions = [
              "--health-cmd=curl -f localhost:9999/dav/version.txt || exit 1"
            ];
          };
        };
      };
    };

    services = {
      jellyfin = {
        enable = true;
        inherit user group;
      };
      jellyseerr = enabled;
    };

    systemd = {
      services =
        let
          afterZurg = {
            after = [ "podman-zurg.service" ];
            requires = [ "podman-zurg.service" ];
            partOf = [ "arrs-root.target" ];
            wantedBy = [ "arrs-root.target" ];
          };
        in
        {
          "podman-riven" = {
            serviceConfig = {
              Restart = lib.mkOverride 500 "always";
            };
            partOf = [ "arrs-root.target" ];
            wantedBy = [ "arrs-root.target" ];
          };
          "podman-riven-db" = {
            serviceConfig = {
              Restart = lib.mkOverride 500 "no";
            };
            partOf = [ "arrs-root.target" ];
            wantedBy = [ "arrs-root.target" ];
          };
          "podman-riven-frontend" = {
            serviceConfig = {
              Restart = lib.mkOverride 500 "always";
            };
            partOf = [ "arrs-root.target" ];
            wantedBy = [ "arrs-root.target" ];
          };
          "podman-rclone" = {
            serviceConfig = {
              Restart = lib.mkOverride 500 "always";
            };
            partOf = [ "arrs-root.target" ];
            wantedBy = [ "arrs-root.target" ];
          };
          "podman-zurg" = {
            serviceConfig = {
              Restart = lib.mkOverride 500 "always";
            };
            partOf = [ "arrs-root.target" ];
            wantedBy = [ "arrs-root.target" ];
          };
          jellyfin = afterZurg;
          jellyseerr = afterZurg;
        };

      targets."arrs-root" = {
        unitConfig.Description = "Root target for arrs stack.";
        wantedBy = [ "multi-user.target" ];
      };

      # create all paths for mounts
      tmpfiles.rules = [
        "d ${path} - ${user} ${group} -"
        "d ${path}/jellyfin - ${user} ${group} -"
        "d ${path}/jellyfin/movies - ${user} ${group} -"
        "d ${path}/jellyfin/shows - ${user} ${group} -"
        "d ${path}/remote - ${user} ${group} -"
        "d ${path}/remote/realdebrid - ${user} ${group} -"
      ];
    };

    environment.persistence.${config.camms.impermanence.path} = mkIf config.camms.impermanence.enable {
      directories = [
        "/var/cache/jellyfin"
        "/var/lib/jellyfin"
        "/var/lib/private/jellyseerr"
        "/var/lib/riven"
        "/var/lib/zurg"
      ];
    };
  };
}

{
  lib,
  namespace,
  config,
  ...
}:
let
  cfg = config.${namespace}.services.arrs;
  path = "${cfg.statePath}";
  user = "cameron";
  group = "media";
in
with lib;
with lib.${namespace};
{
  options.${namespace}.services.arrs = {
    enable = mkEnableOption "arrs stack";
    statePath = mkOption {
      type = types.str;
      default = "/media/arrs";
      description = "The location of the mounts and media files";
    };
  };

  config = mkIf cfg.enable {
    users.groups.${group}.members = [ "${user}" ];

    virtualisation.oci-containers.containers = {
      "blackhole" = {
        image = "ghcr.io/westsurname/scripts/blackhole:latest";
        environmentFiles = [ /var/lib/blackhole/.env ];
        environment = {
          BLACKHOLE_BASE_WATCH_PATH = "/mnt/symlinks";
        };
        volumes = [
          "${path}:/mnt:rw"
          "/var/cache/blackhole/logs:/app/logs:rw"
          "${path}/remote/realdebrid/torrents:/mnt/remote/realdebrid/torrents:rw"
          "${path}/symlinks:/mnt/symlinks:rw"
        ];
        dependsOn = [ "rclone" ];
        log-driver = "journald";
        extraOptions = [ "--network=host" ];
      };
      "rclone" = {
        image = "rclone/rclone:latest";
        environment = {
          "TZ" = "Etc/UTC";
        };
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
          "--network=host"
          "--security-opt=apparmor:unconfined"
        ];
      };
      "zurg" = {
        image = "ghcr.io/debridmediamanager/zurg-testing:v0.9.3-final";
        volumes = [
          "/var/lib/zurg/config.yml:/app/config.yml:rw"
          "/var/lib/zurg/data:/app/data:rw"
        ];
        log-driver = "journald";
        extraOptions = [
          "--health-cmd=curl -f localhost:9999/dav/version.txt || exit 1"
          "--network=host"
        ];
      };
    };

    services =
      let
        enable = {
          enable = true;
          user = "${user}";
          group = "${group}";
        };
      in
      {
        jellyfin = enable;
        jellyseerr = enabled;
        radarr = enable;
        sonarr = enable;
        prowlarr = enabled;
      };

    systemd = {
      services =
        let
          afterBlackhole = {
            after = [ "podman-blackhole.service" ];
            requires = [ "podman-blackhole.service" ];
            partOf = [ "arrs-root.target" ];
            wantedBy = [ "arrs-root.target" ];
          };
        in
        {
          "podman-blackhole" = {
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
          jellyfin = afterBlackhole;
          jellyseerr = afterBlackhole;
          radarr = afterBlackhole;
          sonarr = afterBlackhole;
          prowlarr = afterBlackhole;
        };

      # Root service
      # When started, this will automatically create all resources and start
      # the containers. When stopped, this will teardown all resources.
      targets."arrs-root" = {
        unitConfig.Description = "Root target for arrs stack.";
        wantedBy = [ "multi-user.target" ];
      };

      tmpfiles.rules = [
        "d ${path} - ${user} ${group} -"
        "d ${path}/jellyfin - ${user} ${group} -"
        "d ${path}/jellyfin/movies - ${user} ${group} -"
        "d ${path}/jellyfin/shows - ${user} ${group} -"
        "d ${path}/remote - ${user} ${group} -"
        "d ${path}/remote/realdebrid - ${user} ${group} -"
        "d ${path}/symlinks - ${user} ${group} -"
        "d ${path}/symlinks/radarr - ${user} ${group} -"
        "d ${path}/symlinks/sonarr - ${user} ${group} -"
        "d ${path}/symlinks/radarr/completed - ${user} ${group} -"
        "d ${path}/symlinks/sonarr/completed - ${user} ${group} -"
      ];
    };

    environment.persistence.${config.${namespace}.impermanence.path} =
      mkIf config.${namespace}.impermanence.enable
        {
          directories = [
            "/var/lib/jellyfin"
            "/var/lib/private/jellyseerr"
            "/var/lib/private/prowlarr"
            "/var/lib/radarr"
            "/var/lib/sonarr"
            "/var/lib/zurg"
            "/var/cache/jellyfin"
            "/var/cache/blackhole"
          ];
          files = [
            "/var/lib/blackhole/.env"
          ];
        };
  };
}

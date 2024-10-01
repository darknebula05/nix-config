{
  lib,
  namespace,
  config,
  ...
}:
let
  cfg = config.${namespace};
  realdebridMount = "/mnt/remote/realdebrid/torrents/";
  baseWatch = "/mnt/symlinks";
  radarrPath = "${baseWatch}/radarr";
  sonarrPath = "${baseWatch}/sonarr";
in
with lib;
with lib.${namespace};
{
  options.${namespace}.arrs.enable = mkEnableOption "arrs stack";

  config = mkIf cfg.arrs.enable {
    users.groups.media.members = [ "cameron" ];

    virtualisation.oci-containers.containers = {
      "blackhole" = {
        image = "ghcr.io/westsurname/scripts/blackhole:latest";
        environmentFiles = [ /var/lib/blackhole/.env ];
        environment = {
          BLACKHOLE_BASE_WATCH_PATH = "${baseWatch}";
        };
        volumes = [
          "/mnt:/mnt:rw"
          "/var/cache/blackhole/logs:/app/logs:rw"
          "${realdebridMount}:${realdebridMount}:rw"
          "${radarrPath}:${radarrPath}:rw"
          "${sonarrPath}:${sonarrPath}:rw"
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
          "/mnt:/mnt:rw"
          "/mnt/remote/realdebrid:/data:rw,rshared"
        ];
        cmd = [
          "mount"
          "zurg:"
          "/data"
          "--allow-non-empty"
          "--allow-other"
          "--uid=1000"
          "--gid=1000"
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

    services = {
      jellyfin = {
        enable = true;
        user = "cameron";
        group = "media";
      };
      jellyseerr = enabled;
      radarr = {
        enable = true;
        user = "cameron";
        group = "media";
      };
      sonarr = {
        enable = true;
        user = "cameron";
        group = "media";
      };
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
    };

    environment.persistence.${cfg.impermanence.path} = mkIf cfg.impermanence.enable {
      directories = [
        "/var/lib/jellyfin"
        "/var/lib/private/jellyseerr"
        "/var/lib/private/prowlarr"
        "/var/lib/radarr"
        "/var/lib/sonarr"
        "/var/lib/zurg"
      ];
      files = [
        "/var/lib/blackhole/.env"
      ];
    };
  };
}

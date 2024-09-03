{ config, pkgs-unstable, ... }:
let
  drivePath = "/data";
  tailnet = "dusky-atria.ts.net";
in
{
  services.caddy = {
    enable = true;
    package = pkgs-unstable.caddy;
    globalConfig = ''
      grace_period 10s
      tailscale {
        ephemeral
      }
    '';
    virtualHosts = {
      "jellyfin.${tailnet}".extraConfig = ''
        bind tailscale/jellyfin
        encode
        reverse_proxy localhost:8096
      '';
      "yarr.${tailnet}".extraConfig = ''
        bind tailscale/yarr
        encode
        reverse_proxy localhost:7070
      '';
    };
  };
  services.tailscale.permitCertUid = config.services.caddy.user;
  age.secrets.caddy-environment.file = ./caddy-environment.age;
  systemd.services.caddy.serviceConfig.EnvironmentFile = config.age.secrets.caddy-environment.path;

  services.jellyfin = rec {
    enable = true;
    cacheDir = "${dataDir}/cache";
    dataDir = "${drivePath}/jellyfin";
  };

  services.syncthing = rec {
    dataDir = "${drivePath}/sync";
    user = "root";
    settings.folders = {
      backup = {
        path = "${dataDir}/backup";
        devices = [
          "ecliptic"
          "moonrise"
        ];
        ignorePerms = true;
        type = "receiveonly";
        versioning.type = "trashcan";
      };
      reverie = {
        path = "${dataDir}/reverie";
        devices = [
          "ecliptic"
          "moonrise"
        ];
        ignorePerms = true;
        type = "receiveonly";
        versioning.type = "trashcan";
      };
      music = {
        path = "${drivePath}/media/music";
        devices = [ "moonrise" ];
        ignorePerms = true;
        versioning.type = "trashcan";
      };
    };
  };

  services.yarr.enable = true;
}

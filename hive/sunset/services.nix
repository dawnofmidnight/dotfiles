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
      "nix-cache.${tailnet}".extraConfig = ''
        bind tailscale/nix-cache
        encode
        reverse_proxy localhost:${builtins.toString config.services.nix-serve.port}
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

  age.secrets.cache-private-key.file = ./cache-private-key.age;
  services.nix-serve = {
    enable = true;
    secretKeyFile = config.age.secrets.cache-private-key.path;
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

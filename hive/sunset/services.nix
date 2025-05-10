{ config, pkgs, ... }:
let
  drivePath = "/data";
  tailnet = "dusky-atria.ts.net";
in
{
  services.caddy = {
    enable = true;
    package = pkgs.caddy.withPlugins {
      plugins = [ "github.com/tailscale/caddy-tailscale@v0.0.0-20250508175905-642f61fea3cc" ];
      hash = "sha256-q7NYHDtcE6GtjG4dYfFJ4IVO8dn/P8ZzhzXTYHEIihY=";
    };
    globalConfig = ''
      grace_period 10s
      tailscale {
        ephemeral
      }
    '';
    virtualHosts = {
      "calibre-server.${tailnet}".extraConfig = ''
        bind tailscale/calibre-server
        encode
        reverse_proxy localhost:${builtins.toString config.services.calibre-server.port}
      '';
      "calibre-web.${tailnet}".extraConfig = ''
        bind tailscale/calibre-web
        encode
        reverse_proxy localhost:${builtins.toString config.services.calibre-web.listen.port}
      '';
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
      "sunset.${tailnet}".extraConfig = ''
        encode
        file_server browse
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

  services.calibre-server = {
    enable = true;
    auth = {
      enable = true;
      mode = "basic";
      userDb = "${drivePath}/media/books/users.db";
    };
    libraries = [ "${drivePath}/media/books" ];
  };

  services.calibre-web = {
    enable = true;
    options = {
      enableBookConversion = true;
      enableBookUploading = true;
      calibreLibrary = "${drivePath}/media/books";
    };
  };

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
        versioning.type = "simple";
      };
      reverie = {
        path = "${dataDir}/reverie";
        devices = [
          "ecliptic"
          "moonrise"
        ];
        ignorePerms = true;
        type = "receiveonly";
        versioning.type = "simple";
      };
      music = {
        path = "${drivePath}/media/music";
        devices = [ "moonrise" ];
        ignorePerms = true;
        versioning.type = "simple";
      };
    };
  };

  services.yarr.enable = true;
}

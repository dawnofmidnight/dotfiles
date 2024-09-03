{ config, ... }:
{
  services.syncthing = {
    dataDir = config.users.users.dawn.home;
    configDir = "${config.home-manager.users.dawn.xdg.configHome}/syncthing";
    user = "dawn";
    settings.folders = {
      backup = {
        path = "${config.users.users.dawn.home}/backup";
        devices = [
          "ecliptic"
          "sunset"
        ];
        versioning.type = "trashcan";
      };
      reverie = {
        path = "${config.users.users.dawn.home}/notes/reverie";
        devices = [
          "ecliptic"
          "sunset"
        ];
        versioning.type = "trashcan";
        fsWatcherEnabled = false;
      };
      music = {
        path = "${config.users.users.dawn.home}/music";
        devices = [ "sunset" ];
        versioning.type = "trashcan";
      };
    };
  };

  virtualisation = rec {
    containers.enable = podman.enable;
    podman = {
      enable = true;
      dockerCompat = podman.enable;
      defaultNetwork.settings.dns_enabled = podman.enable;
    };
  };
}

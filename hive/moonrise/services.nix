{ config, ... }:
{
  programs.gnupg.agent.enable = true;

  # seahorse provides an askpass helper that is necessary for when programs
  # such as `jj` need a password in a subprocess that doesn't have terminal
  # access. seahorse was chosen simply because it was the first attempt that
  # worked.
  programs.seahorse.enable = true;

  programs.ssh = {
    enableAskPassword = true;
    startAgent = true;
  };

  services.auto-cpufreq.enable = true;
  services.thermald.enable = true;

  services.earlyoom = {
    enable = true;
    enableNotifications = true;
  };

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
        versioning.type = "simple";
      };
      music = {
        path = "${config.users.users.dawn.home}/music";
        devices = [ "sunset" ];
        versioning.type = "simple";
      };
      reverie = {
        path = "${config.users.users.dawn.home}/notes/reverie";
        devices = [
          "ecliptic"
          "sunset"
        ];
        versioning.type = "simple";
        fsWatcherEnabled = false;
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

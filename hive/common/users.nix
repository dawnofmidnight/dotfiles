{ config, util, ... }:
{
  users = {
    mutableUsers = false;
    users = {
      root.openssh.authorizedKeys.keys = util.ssh-keys.users ++ util.ssh-keys.hosts;

      dawn = {
        isNormalUser = true;
        home = "/home/dawn";
        extraGroups = [
          "networkmanager"
          "wheel"
          "disk"
        ];
        shell = config.home-manager.users.dawn.dawn.shell.default.package;
        hashedPassword = "$6$uoZ.rTXg6dTjo2YX$.jM2IUykJuOeBxMqQyfG6qlopcj9zh6LWFb2RrQdarwNaigZm3gXI3Ew8FY03EHivOfLMNlDWUaJ8p9T4F/Tn1";
        openssh.authorizedKeys.keys = util.ssh-keys.users ++ util.ssh-keys.hosts;
      };
    };
  };

  home-manager.users.dawn = {
    imports = [ ../../home ];

    programs.home-manager.enable = true;

    home = {
      stateVersion = "24.11";
      username = "dawn";
      homeDirectory = config.users.users.dawn.home;
    };

    dawn.vcs.user = {
      name = "dawnofmidnight";
      email = "dawnofmidnight@duck.com";
    };

    xdg.enable = true;
  };
}

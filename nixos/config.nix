{ config, pkgs, pkgs-unstable, ... }: {
  programs.dconf.enable = true;

  services.greetd = {                                                      
    enable = true;                                                         
    settings = {                                                           
      default_session = {                                                  
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd river";
        user = "greeter";                                                  
      };                                                                   
    };                                                                     
  };

  services.syncthing = {
    enable = true;
    user = "dawn";
    dataDir = "${config.users.users.dawn.home}/notes";
    overrideDevices = true;
    overrideFolders = true;
    settings = {
      devices.ecliptic = { id = "H5QYJW2-4LP5GH3-6LWMIKI-7RLICUU-ZJ4QXQQ-MWQ262Q-AA5M6O7-VBORCQF"; };
      folders.reverie = {
        path = "${config.users.users.dawn.home}/notes/reverie";
        devices = [ "ecliptic" ];
      };
    };
  };
  systemd.services.syncthing.environment.STNODEFAULTFOLDER = "true";

  services.tailscale = {
    enable = true;
    package = pkgs-unstable.tailscale;
  };

  fonts = {
    packages = with pkgs; [
      crimson
      fira-sans
      lmodern
      (nerdfonts.override { fonts = [ "Iosevka" "IosevkaTerm" ]; })
      noto-fonts-emoji
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = [ "Crimson" ];
        sansSerif = [ "Fira Sans" ];
        monospace = [ "Iosevka Nerd Font" ];
      };
    };
  };

  virtualisation = {
    containers.enable = true;
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  environment.systemPackages = with pkgs; [
    libreoffice-qt
    hunspell
    hunspellDicts.en_US
  ];

  # necessary for electron apps (vscode in particular) to load in wayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}

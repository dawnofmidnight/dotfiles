{ config, inputs, pkgs, pkgs-unstable, ... }: {
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
    grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      useOSProber = true;
    };
  };
  # lg gram drivers require newer kernel
  boot.kernelPackages = pkgs.linuxPackages_6_10;

  networking = {
    networkmanager.enable = true;
    hostName = "moonrise";
  };

  time.timeZone = "America/New_York";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };

  environment.systemPackages = with pkgs; [
    libreoffice-qt
    hunspell
    hunspellDicts.en_US
  ];

  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [ intel-media-driver intel-ocl intel-vaapi-driver ];
  };

  security.polkit.enable = true;

  # necessary for vscode to load in wayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  services.printing.enable = true;

  sound.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    jack.enable = true;
    pulse.enable = true;
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

  users = {
    mutableUsers = false;
    users.dawn = {
      isNormalUser = true;
      home = "/home/dawn";
      extraGroups = [ "networkmanager" "video" "wheel" ];
      shell = pkgs-unstable.nushell;
      hashedPassword = "$y$j9T$O7TCsYTix3J1Fu2PCZ/Pp1$iOIT6e2tn2kdZNRz09UIy1QgaoWbwBNczZItsDuiAw9";
    };
  };

  programs.light.enable = true;

  programs.firefox.enable = true;

  nixpkgs.config.allowUnfree = true;
  nix = {
    registry = {
      pkgs.flake = inputs.nixpkgs;
      pkgs-unstable.flake = inputs.nixpkgs-unstable;
    };

    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
    };

    gc = {
      automatic = true;
      options = "--delete-older-than 1w";
    };
  };

  home-manager.backupFileExtension = "backup";

  system.stateVersion = "24.05";

  fonts = {
    packages = with pkgs; [
      fira-sans
      (nerdfonts.override { fonts = [ "Iosevka" "IosevkaTerm" ]; })
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
        sansSerif = [ "Fira Sans" ];
        monospace = [ "Iosevka Nerd Font" ];
      };
    };
  };

  documentation.man.generateCaches = true;
  
  services.greetd = {                                                      
    enable = true;                                                         
    settings = {                                                           
      default_session = {                                                  
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd river";
        user = "greeter";                                                  
      };                                                                   
    };                                                                     
  };

  # # swaylock won't unlock correctly if this isn't here
  security.pam.services.swaylock = {};

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  services.blueman.enable = true;
}

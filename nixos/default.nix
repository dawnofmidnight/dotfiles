{ config, inputs, pkgs, pkgs-unstable, ... }: {
  imports = [
    ./hardware-configuration.nix
  ];

  system.stateVersion = "24.05";

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

  boot = {
    # lg gram drivers require newer kernel
    kernelPackages = pkgs.linuxPackages_6_10;
    loader = {    
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
  };

  networking = {
    networkmanager.enable = true;
    hostName = "moonrise";
  };

  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [ intel-media-driver intel-ocl intel-vaapi-driver ];
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  services.blueman.enable = true;

  security.polkit.enable = true;

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

  programs.light.enable = true;

  services.printing.enable = true;

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

  # # swaylock won't unlock correctly if this isn't here
  security.pam.services.swaylock = {};

  virtualisation = {
    containers.enable = true;
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  fonts = {
    packages = with pkgs; [
      crimson
      fira-sans
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

  environment.systemPackages = with pkgs; [
    libreoffice-qt
    hunspell
    hunspellDicts.en_US
  ];

  # necessary for electron apps (vscode in particular) to load in wayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

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
}

{ config, inputs, pkgs, pkgs-unstable, ... }: {
  imports = [
    ./hardware-configuration.nix
  ];

  # Bootloader.
  # boot.loader.systemd-boot.enable = true;
  # boot.loader.efi.canTouchEfiVariables = true;
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

  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    videoDrivers = [ "modesetting" ];
    xkb = {
      layout = "us";
      variant = "";
    };
  };
  programs.dconf = {
    enable = true;
    profiles.user.databases = [
      {
        lockAll = true;
        settings = {
          "org/gnome/mutter".experimental-features = [ "scale-monitor-framebuffer" ];
        };
      }
    ];
  };

  # necessary for vscode to load in wayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  services.printing.enable = true;

  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
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
      extraGroups = [ "networkmanager" "wheel" ];
      shell = pkgs-unstable.nushell;
      hashedPassword = "$y$j9T$O7TCsYTix3J1Fu2PCZ/Pp1$iOIT6e2tn2kdZNRz09UIy1QgaoWbwBNczZItsDuiAw9";
    };
  };

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

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  system.stateVersion = "24.05";

  environment.systemPackages = with pkgs; [
    libreoffice-qt
    hunspell
    hunspellDicts.en_US
  ];

  stylix = {
    enable = true;
    image = ./wallpaper.jpg;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/rose-pine-dawn.yaml";
    cursor = {
      package = pkgs.rose-pine-cursor;
      name = "BreezeX-RosePineDawn-Linux";
    };
    fonts = {
      monospace = {
        package = pkgs.iosevka;
        name = "Iosevka";
      };
      sansSerif = {
        package = pkgs.fira-sans;
        name = "Fira Sans";
      };
      sizes.applications = 10;
      # sizes.desktop = 11;
      # sizes.popups = 11;
      # sizes.terminal = 11;
    };
  };

  # certain fonts are screwed up without this (2024-09-03)
  environment.sessionVariables.GSK_RENDERER = "gl";
}

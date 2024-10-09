{ config, inputs, pkgs, system, ... }: {
  imports = [
    ./hardware-configuration.nix
  ];

   environment.systemPackages = [
    inputs.agenix.packages.${system}.default
    inputs.colmena.defaultPackage.${system}
    pkgs.brightnessctl
  ];

  boot = {
    consoleLogLevel = 0;
    # lg gram drivers require newer kernel
    kernelPackages = pkgs.linuxPackages_6_10;
    kernelParams = [ "quiet" ];
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

  hardware = {
    opengl.enable = true;
    bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings.General.Experimental = true;
    };
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

  # swaylock won't unlock correctly if this isn't here
  security.pam.services.swaylock = {};

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
  
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  environment.sessionVariables.ELECTRON_OZONE_PLATFORM_HINT = "auto";

  virtualisation = {
    containers.enable = true;
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };
}

{
  config,
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    ./disk-config.nix
    inputs.disko.nixosModules.disko
    inputs.lanzaboote.nixosModules.lanzaboote
  ];

  disko.devices.disk.main.device = "/dev/disk/by-id/nvme-HFS001TEJ9X108N_4YD2N032710402T4H";

  boot = {
    consoleLogLevel = 0;

    initrd = {
      verbose = false;
      systemd.enable = true;
      luks.devices.root = {
        bypassWorkqueues = true;
        crypttabExtraOpts = [ "fido2-device=auto" ];
        device = "/dev/disk/by-uuid/2d15366c-e177-4c38-9d70-b3b3f7c58498";
      };
    };

    # niri fails to start when the kernel isn't set
    kernelPackages = pkgs.linuxKernel.packages.linux_6_13;
    kernelParams = [
      "quiet"
      "udev.log_level=3"
    ];

    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
    };

    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      systemd-boot.windows.windows = {
        title = "Windows";
        efiDeviceHandle = "HD0e";
        sortKey = "y_windows";
      };
    };

    binfmt.emulatedSystems = [ "aarch64-linux" ];
  };

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 32 * 1024;
    }
  ];

  networking.hostName = "moonrise";

  hardware = {
    graphics.enable = true;
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };

  programs.nix-ld.enable = true;

  services.blueman.enable = true;

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd ${config.home-manager.users.dawn.dawn.desktop.wm.binary}";
        user = "greeter";
      };
    };
  };

  services.keyd = {
    enable = true;
    keyboards.default = {
      ids = [ "*" ];
      settings.main.capslock = "esc";
    };
  };

  # makes thunderbolt work
  services.hardware.bolt.enable = true;

  # gives nautilus more permissions for network drives and the like
  services.gvfs.enable = true;

  # swaylock won't unlock correctly if this isn't here
  security.pam.services.swaylock = { };

  # needed for yubico authenticator functionality
  services.pcscd.enable = true;

  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    jack.enable = true;
    pulse.enable = true;
  };

  # needed for samba mounting
  security.polkit.enable = true;

  # recommended for pipewire
  security.rtkit.enable = true;

  # allows configuring desktop things/gtk
  programs.dconf.enable = true;

  # mount the ncsu drive
  environment.systemPackages = [ pkgs.cifs-utils ];
  age.secrets.ncsu-mount-config.file = ./ncsu-mount-config.age;
  fileSystems."/mnt/ncsu" = {
    device = "//ncsudrive.ncsu.edu/home";
    fsType = "cifs";
    options = [
      "noauto"
      "uid=1000"
      "gid=100"
      "mfsymlinks"
      "credentials=${config.age.secrets.ncsu-mount-config.path}"
    ];
  };

  nix = {
    buildMachines = [
      {
        hostName = "152.7.58.97";
        maxJobs = 4;
        protocol = "ssh-ng";
        sshUser = "remote-build";
        sshKey = "/etc/ssh/remote-build";
        system = "aarch64-linux";
        supportedFeatures = [
          "benchmark"
          "big-parallel"
          "gccarch-armv8-a"
          "kvm"
          "nixos-test"
        ];
      }
    ];
    distributedBuilds = true;
    settings = {
      substituters = [
        # "https://cache.nixos.org?priority=40"
        "https://nix-cache.dusky-atria.ts.net?priority=50"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-cache.dusky-atria.ts.net:MXbD6lTa1Fg1FfPkjnvREOaHT0gnMon9YjI815BY7g4="
      ];
    };
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    configPackages = [
      pkgs.gnome-keyring
      pkgs.xdg-desktop-portal-gnome
      pkgs.xdg-desktop-portal-gtk
    ];
    config.common.default = "*";
  };
}

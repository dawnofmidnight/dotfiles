{ inputs, ... }:
{
  imports = [ inputs.nixos-hardware.nixosModules.raspberry-pi-5 ];

  fileSystems."/data" = {
    device = "/dev/disk/by-uuid/5E9F-F9B9";
    fsType = "exfat";
    options = [
      "rw"
      "suid"
      "dev"
      "exec"
      "auto"
      "nouser"
      "async"
      "nofail"
      "umask=000"
    ];
  };

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = false;
  };

  networking = {
    hostName = "sunset";
    firewall.allowedTCPPorts = [
      80
      443
    ];
  };
}

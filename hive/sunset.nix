{ inputs, ... }: {
  imports = [
    "${inputs.nixpkgs}/nixos/modules/virtualisation/digital-ocean-image.nix"
  ];

  networking.hostName = "sunset";

  swapDevices = [{
    device = "/swap/swapfile";
    size = 1024 * 2;
  }];

  virtualisation.digitalOceanImage.compressionMethod = "bzip2";
}

{ inputs, ... }: {
  imports = [
    "${inputs.nixpkgs}/nixos/modules/virtualisation/digital-ocean-image.nix"
  ];

  virtualisation.digitalOceanImage.compressionMethod = "bzip2";

  networking.hostName = "sunset";

  services.freshrss = {
    enable = true;
    authType = "none";
    baseUrl = "sunset";
  };
}

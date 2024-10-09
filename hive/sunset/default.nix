{ config, inputs, lib, pkgs, ... }: {
  imports = [
    "${inputs.nixpkgs}/nixos/modules/virtualisation/digital-ocean-image.nix"
  ];

  virtualisation.digitalOceanImage.compressionMethod = "bzip2";

  networking = {
    hostName = "sunset";
    firewall.allowedTCPPorts = [ 80 443 ];
  };

  services.caddy = {
    enable = true;
    virtualHosts = {
      "*.dawnofmidnight.me".extraConfig = ''
        tls {
          dns cloudflare {env.CLOUDFLARE_API_TOKEN}
        }
      '';
    
      "www.dawnofmidnight.me".extraConfig = ''
        respond "hello world"
      '';
    }; 
  };

  age.secrets.caddy-env.file = ./caddy-env.age;
  systemd.services.caddy.serviceConfig.EnvironmentFile = config.age.secrets.caddy-env.path;
}

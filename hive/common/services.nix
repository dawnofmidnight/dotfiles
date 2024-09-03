{
  config,
  pkgs,
  pkgs-unstable,
  ...
}:
{
  networking = {
    # nameservers = [
    #   "127.0.0.1"
    #   "::1"
    # ];
    networkmanager = {
      enable = true;
      # dns = "none";
      # NOTE: to disable for a specific network, run `nmcli connection modify
      #       <ssid> wifi.cloned-mac-address permanent` (or replace
      #       `permanent` with `stable`, `stable-ssid`, etc. as necessary)
      # TODO: figure how to edit `/etc/NetworkManager/system-connections` to do
      #       that declaratively
      wifi.macAddress = "random";
    };
  };

  services.dnscrypt-proxy2 = {
    # enable = true;
    upstreamDefaults = true;
    settings = {
      server_names = [
        "quad9-doh-ip4-port443-filter-pri"
        "cloudflare"
      ];
      # forwarding_rules = pkgs.writeText "forwarding-rules.txt" "ncsu.edu $DHCP,152.1.14.69,152.1.14.14,152.1.14.12";
      forwarding_rules = pkgs.writeText "forwarding-rules.txt" "ncsu.edu $DHCP";
      dnscrypt_servers = false;
      doh_servers = true;
      require_dnssec = true;
      require_nolog = true;
      sources.public-resolvers = {
        urls = [
          "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
          "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
        ];
        minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
        cache_file = "/var/lib/dnscrypt-proxy/public-resolvers.md";
      };
    };
  };
  systemd.services.dnscrypt-proxy2.serviceConfig.StateDirectory = "dnscrypt-proxy";

  services.earlyoom.enable = true;

  programs.ssh.startAgent = true;
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "prohibit-password";
      PasswordAuthentication = false;
    };
  };

  age.secrets.tailscale-auth-key.file = ./tailscale-auth-key.age;
  services.tailscale = {
    enable = true;
    package = pkgs-unstable.tailscale;
    authKeyFile = config.age.secrets.tailscale-auth-key.path;
    extraUpFlags = [
      "--ssh"
      "--operator=dawn"
    ];
  };

  services.syncthing = {
    enable = true;
    overrideDevices = true;
    overrideFolders = true;
    settings.devices = {
      ecliptic.id = "JHLKMDP-Y3SJBXW-CJUFAAK-FS4HFE2-FFUFAIS-4Q5YN2B-TXYFJGD-F3E5YAJ";
      moonrise.id = "RFR37AB-3BO7TF6-EZBED57-TRHG4SM-FIF5VS6-OW5Z27Z-2LNLCPG-FXRG3AG";
      sunset.id = "FBCUHYL-6G66XUK-OJOZ6CU-UXPGG72-ZU23KGC-2RXVSI6-OVOJ5MF-SROSSAE";
    };
  };
  systemd.services.syncthing.environment.STNODEFAULTFOLDER = "true";
}

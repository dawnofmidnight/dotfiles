{ config, pkgs-unstable, ... }:
{
  networking.networkmanager = {
    enable = true;
    # NOTE: to disable for a specific network, run `nmcli connection modify
    #       <ssid> wifi.cloned-mac-address permanent` (or replace
    #       `permanent` with `stable`, `stable-ssid`, etc. as necessary)
    # TODO: figure how to edit `/etc/NetworkManager/system-connections` to do
    #       that declaratively
    wifi.macAddress = "random";
  };

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "prohibit-password";
      PubkeyAuthentication = "yes";
      PubkeyAuthOptions = "verify-required";
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
      # sunset.id = "FBCUHYL-6G66XUK-OJOZ6CU-UXPGG72-ZU23KGC-2RXVSI6-OVOJ5MF-SROSSAE";
      sunset.id = "JCIVJN7-MZIDPGW-5U3HTHM-5PU5TMB-3RZISQI-54TB6D7-Q6WTOP6-J64K3AC";
    };
  };
  systemd.services.syncthing.environment.STNODEFAULTFOLDER = "true";
}

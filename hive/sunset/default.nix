{ util, ... }:
{
  imports = [
    ./core.nix
    ./hardware-configuration.nix
    ./services.nix
  ];

  home-manager.users.dawn.dawn = {
    editors.helix = true;
    languages.nix = true;
    shell = {
      fish = true;
      default.which = "fish";
    };
    vcs.enable = true;
  };

  # https://wiki.nixos.org/wiki/Distributed_build#Using_remote_builders_as_substituters
  nix.settings.secret-key-files = "/var/cache-priv-key.pem";

  users = {
    users.remote-build = {
      isNormalUser = true;
      createHome = false;
      group = "remote-build";
      openssh.authorizedKeys.keys = [ util.ssh-keys.remote-build ];
    };

    groups.remote-build = { };
  };
}

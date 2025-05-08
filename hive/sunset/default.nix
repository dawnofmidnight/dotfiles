{ util, ... }:
{
  imports = [
    ./core.nix
    ./hardware-configuration.nix
    ./services.nix
  ];

  documentation = {
    dev.enable = false;
    info.enable = false;
    man.enable = false;
    nixos.enable = false;
  };

  home-manager.users.dawn.dawn = {
    editors.helix = true;
    languages.nix = true;
    shell.fish = true;
    vcs.enable = true;
  };

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

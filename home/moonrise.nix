{ config, pkgs, ... }: {
  imports = [
    ./audio.nix
    ./desktop
    ./dev
    ./fonts.nix
    ./internet.nix
    ./shell
    ./terminal.nix
  ];

  vcs = {
    enable = true;
    user = {
      name = "dawnofmidnight";
      email = "dawnofmidnight@duck.com";
    };
  };

  xdg = {
    enable = true;
    userDirs = {
      download = "${config.home.homeDirectory}/downloads";
      music = "${config.home.homeDirectory}/music";
    };
  };
  
  home.packages = with pkgs; [
    hunspell
    hunspellDicts.en_US
    just
    libreoffice-qt
    obsidian
    qalculate-gtk
  ];

  home.sessionVariables.NIXOS_OZONE_WL = "1";
}

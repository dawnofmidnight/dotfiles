{ pkgs, ... }: {
  imports = [
    ./audio.nix
    ./desktop
    ./dev
    ./internet.nix
    ./shell
  ];

  home = {
    username = "dawn";
    homeDirectory = "/home/dawn";
    packages = with pkgs; [ obsidian qalculate-gtk ];
  };

  vcs = {
    enable = true;
    user = {
      name = "dawnofmidnight";
      email = "dawnofmidnight@duck.com";
    };
  };

  xdg.enable = true;
  
  programs.home-manager.enable = true;
  home.stateVersion = "24.05";
}

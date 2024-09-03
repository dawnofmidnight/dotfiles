{ pkgs, ... }: {
  home = {
    username = "dawn";
    homeDirectory = "/home/dawn";
  };

  vcs = {
    enable = true;
    user = {
      name = "dawnofmidnight";
      email = "dawnofmidnight@duck.com";
    };
  };
  
  # programs.thunderbird.enable = true;

  home.packages = with pkgs; [ obsidian ];

  programs.home-manager.enable = true;
  home.stateVersion = "24.05";
}

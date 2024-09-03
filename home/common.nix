{ pkgs, ... }: {
  imports = [
    ./audio.nix
    ./dev
    ./desktop
    ./internet.nix
    ./terminal
  ];

  xdg.enable = true;

  home.packages = with pkgs; [ qalculate-gtk ];
}

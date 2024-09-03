{ pkgs, ... }: {
  programs.chromium = {
    enable = true;
    package = pkgs.google-chrome;
  };
  programs.firefox.enable = true;
}
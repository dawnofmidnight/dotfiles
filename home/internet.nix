{ pkgs, ... }: {
  programs.chromium = {
    enable = true;
    package = pkgs.google-chrome;
  };
  programs.firefox.enable = true;

  programs.thunderbird = {
    enable = true;
    profiles.main.isDefault = true;
  };
}
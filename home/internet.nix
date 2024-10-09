{ pkgs-unstable, ... }: {
  programs.chromium = {
    enable = true;
    package = pkgs-unstable.google-chrome;
  };
  programs.firefox.enable = true;

  programs.thunderbird = {
    enable = true;
    profiles.main.isDefault = true;
  };
}

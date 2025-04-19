{
  config,
  lib,
  pkgs-unstable,
  ...
}:
let
  cfg = config.dawn.communication;
in
{
  options.dawn.communication = {
    signal = lib.mkEnableOption "signal";
    thunderbird = lib.mkEnableOption "thunderbird";
  };

  config = {
    programs.thunderbird = {
      enable = cfg.thunderbird;
      package = pkgs-unstable.thunderbird-latest;
      profiles.main.isDefault = true;
    };

    home.packages = lib.lists.optional cfg.signal pkgs-unstable.signal-desktop;
  };
}

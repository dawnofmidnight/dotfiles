{ config, lib, ... }:
let
  cfg = config.dawn.desktop;
in
{
  imports = [
    ./bar.nix
    ./niri.nix
    ./river.nix
    ./theme.nix
    ./utils.nix
  ];

  options.dawn.desktop = {
    wm = {
      which = lib.mkOption {
        type = lib.types.nullOr (
          lib.types.enum [
            "river"
            "niri"
          ]
        );
        default = null;
      };
      binary = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default =
          if cfg.wm.which == "river" then
            lib.getExe config.wayland.windowManager.river.package
          else if cfg.wm.which == "niri" then
            lib.getExe' config.programs.niri.package "niri-session"
          else
            null;
      };
    };
  };

  config = {
    wayland.windowManager.river.enable = cfg.wm.which == "river";
    programs.niri.enable = cfg.wm.which == "niri";
  };
}

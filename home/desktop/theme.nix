{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dawn.desktop.theme;
  apply = config.dawn.desktop.wm.which != null;
in
{
  options.dawn.desktop.theme = {
    cursor = {
      package = lib.mkOption {
        type = lib.types.nullOr lib.types.package;
        default = null;
      };
      name = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
      };
    };
  };

  config = lib.mkIf apply {
    gtk = {
      enable = true;
      iconTheme = {
        package = pkgs.adwaita-icon-theme;
        name = "Adwaita";
      };
    };

    qt.enable = true;

    home.pointerCursor = {
      package = cfg.cursor.package;
      name = cfg.cursor.name;
      size = 24;
      gtk.enable = true;
      x11.enable = true;
    };
  };
}

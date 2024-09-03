{
  config,
  lib,
  pkgs,
  util,
  ...
}:
let
  cfg = config.dawn.launcher;
in
{
  options.dawn.launcher = {
    which = lib.mkOption {
      type = lib.types.nullOr (
        lib.types.enum [
          "fuzzel"
          "rofi"
        ]
      );
      default = null;
    };

    package = lib.mkOption {
      type = lib.types.nullOr lib.types.package;
      default =
        if cfg.which == "fuzzel" then
          config.programs.fuzzel.package
        else if cfg.which == "rofi" then
          config.programs.rofi.package
        else
          null;
    };
  };

  config = {
    programs.fuzzel = lib.mkIf (cfg.which == "fuzzel") {
      enable = true;
      settings.main.width = 80;
    };

    programs.rofi = lib.mkIf (cfg.which == "rofi") {
      enable = true;
      package = pkgs.rofi-wayland;
      font = "Iosevka Nerd Font 12";

      theme =
        let
          inherit (config.lib.formats.rasi) mkLiteral;
          colors = util.colors.rose-pine-dawn;
        in
        {
          "@import" = "default";

          "#window" = {
            background-color = mkLiteral colors.base;
            border = 2;
            border-color = mkLiteral colors.love;
            border-radius = 4;
            padding = 16;
          };

          "#textbox" = {
            text-color = mkLiteral colors.text;
          };

          "#inputbar" = {
            padding = mkLiteral "0 8";
          };

          "#listview" = {
            padding = mkLiteral "8 0 0 0";
          };

          "#element" = {
            padding = mkLiteral "2 8";
            border = mkLiteral "0 0 1 0";
            border-color = mkLiteral colors.highlightMed;
          };

          "#element.normal.normal" = {
            background-color = mkLiteral colors.base;
            text-color = mkLiteral colors.text;
          };

          "#element.alternate.normal" = {
            background-color = mkLiteral colors.base;
            text-color = mkLiteral colors.text;
          };

          "#element.selected.normal" = {
            background-color = mkLiteral "#ebbcba";
            text-color = mkLiteral colors.text;
          };
        };
    };
  };
}

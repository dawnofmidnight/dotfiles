{ config, lib, pkgs, ... }: 
with lib;
let
  cfg = config.programs.zed;
  jsonFormat = pkgs.formats.json { };
in {
  options.programs.zed = {
    enable = mkEnableOption "Zed";
    package = mkPackageOption pkgs "zed-editor" { };

    userSettings = mkOption {
      type = jsonFormat.type;
      default = { };
      example = literalExpression ''
        {
          telemetry = {
            diagnostics = false;
            metrics = false;
          };
          ui_font_size = 16;
          buffer_font_size = 16;
        }
      '';
      description = ''
        Configuration written to Zed's {file}`settings.json`.
      '';
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];

    xdg.configFile."zed/settings.json" = (mkIf (cfg.userSettings != { }) {
      source = jsonFormat.generate "zed-user-settings" cfg.userSettings;
    });
  };
}

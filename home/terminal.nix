{
  config,
  lib,
  util,
  ...
}:
let
  cfg = config.dawn.terminal;
in
{
  options.dawn.terminal = {
    foot = lib.mkEnableOption "foot";
    kitty = lib.mkEnableOption "kitty";
    ghostty = lib.mkEnableOption "ghostty";

    default = {
      which = lib.mkOption {
        type = lib.types.nullOr (
          lib.types.enum (
            lib.optional cfg.foot "foot" ++ lib.optional cfg.kitty "kitty" ++ lib.optional cfg.ghostty "ghostty"
          )
        );
        default = null;
      };

      package = lib.mkOption {
        type = lib.types.nullOr lib.types.package;
        default =
          if cfg.default.which == "foot" then
            config.programs.foot.package
          else if cfg.default.which == "kitty" then
            config.programs.kitty.package
          else if cfg.default.which == "ghostty" then
            config.programs.ghostty.package
          else
            null;
      };
    };

    app-ids = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default =
        lib.lists.optional cfg.foot "foot"
        ++ lib.lists.optional cfg.kitty "kitty"
        ++ lib.lists.optional cfg.ghostty "com.mitchellh.ghostty";
    };
  };

  config = {
    programs.foot = {
      enable = cfg.foot;
      settings =
        let
          colors = util.colors.rose-pine-dawn;
          dehex = lib.strings.removePrefix "#";
        in
        {
          main.font = "monospace:size=11";
          cursor.color = "${dehex colors.text} ${dehex colors.highlightHigh}";
          colors = {
            foreground = dehex colors.text;
            background = dehex colors.base;
            selection-foreground = dehex colors.text;
            selection-background = dehex colors.highlightMed;
            urls = dehex colors.iris;
            regular0 = dehex colors.overlay;
            bright0 = dehex colors.muted;
            regular1 = dehex colors.love;
            bright1 = dehex colors.love;
            regular2 = dehex colors.pine;
            bright2 = dehex colors.pine;
            regular3 = dehex colors.gold;
            bright3 = dehex colors.gold;
            regular4 = dehex colors.foam;
            bright4 = dehex colors.foam;
            regular5 = dehex colors.iris;
            bright5 = dehex colors.iris;
            regular6 = dehex colors.rose;
            bright6 = dehex colors.rose;
            regular7 = dehex colors.text;
            bright7 = dehex colors.text;
          };
        };
    };

    programs.kitty = {
      enable = cfg.kitty;
      font.name = "Iosevka";
      themeFile = "rose-pine-dawn";
    };

    programs.ghostty = {
      enable = cfg.ghostty;
      settings = {
        # background-opacity = 0.9;
        command = lib.getExe config.dawn.shell.package;
        confirm-close-surface = false;
        cursor-style = "bar";
        font-family = config.dawn.fonts.mono.name;
        theme = "rose-pine-dawn";
        resize-overlay = "never";
        selection-foreground = util.colors.rose-pine-dawn.text;
        selection-background = util.colors.rose-pine-dawn.highlightMed;
        window-decoration = false;
      };
    };
  };
}

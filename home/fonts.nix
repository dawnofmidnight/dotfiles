{ config, lib, ... }:
let
  cfg = config.dawn.fonts;
  listIfNonNull = x: lib.lists.optional (x != null) x;
in
{
  options.dawn.fonts = {
    sans = {
      package = lib.mkOption {
        type = lib.types.nullOr lib.types.package;
        default = null;
      };
      name = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
      };
    };

    serif = {
      package = lib.mkOption {
        type = lib.types.nullOr lib.types.package;
        default = null;
      };
      name = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
      };
    };

    mono = {
      package = lib.mkOption {
        type = lib.types.nullOr lib.types.package;
        default = null;
      };
      name = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
      };
    };

    extra = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
    };
  };

  config = {
    home.packages =
      cfg.extra
      ++ listIfNonNull cfg.sans.package
      ++ listIfNonNull cfg.serif.package
      ++ listIfNonNull cfg.mono.package;

    fonts.fontconfig = {
      enable = cfg.sans.name != null || cfg.serif.name != null || cfg.mono.name != null;
      defaultFonts = {
        serif = listIfNonNull cfg.serif.name;
        sansSerif = listIfNonNull cfg.sans.name;
        monospace = listIfNonNull cfg.mono.name;
      };
    };
  };
}

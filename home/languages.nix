{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dawn.languages;
in
{
  options.dawn.languages = {
    java = lib.mkEnableOption "java";
    nix = lib.mkEnableOption "nix";
    r = lib.mkEnableOption "r";
    rust = lib.mkEnableOption "rust";
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.java {
      home.packages = [ pkgs.jdk21 ];

      # makes java swing actually look half-decent for some reason
      home.sessionVariables = {
        _JAVA_AWT_WM_NONREPARENTING = 1;
        _JAVA_OPTIONS = "-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true \
          -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel";
      };
    })

    (lib.mkIf cfg.nix {
      home.packages = [
        pkgs.nixd
        pkgs.nixfmt-rfc-style
        pkgs.nix-output-monitor
      ];
    })

    (lib.mkIf cfg.r { home.packages = [ pkgs.R ]; })

    (lib.mkIf cfg.rust {
      home.packages = [ pkgs.bacon ];

      home.file.".cargo/config.toml".source = (pkgs.formats.toml { }).generate "cargo-config" {
        build.target-dir = "${config.xdg.cacheHome}/cargo-target";
        target.x86_64-unknown-linux-gnu = {
          linker = lib.getExe pkgs.clang;
          rustflags = [
            "-Clink-arg=-fuse-ld=${lib.getExe pkgs.mold}"
            "-Ctarget-cpu=native"
          ];
        };
        unstable.gc = true;
      };
    })
  ];
}

{ config, pkgs, ... }:
let
  inherit (config.lib.formats.rasi) mkLiteral;
  colors = (import ../../lib/colors.nix).rose-pine-dawn;
in {
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    font = "Iosevka Nerd Font 12";

    theme = {
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
}

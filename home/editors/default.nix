{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dawn.editors;
in
{
  imports = [
    ./eclipse.nix
    ./helix.nix
    ./vscode.nix
    ./zed.nix
  ];

  options.dawn.editors = {
    eclipse = lib.mkEnableOption "eclipse";
    helix = lib.mkEnableOption "helix";
    rstudio = lib.mkEnableOption "rstudio";
    vscode = lib.mkEnableOption "vscode";
    zed = lib.mkEnableOption "zed";
  };

  config = {
    programs.eclipse.enable = cfg.eclipse;
    programs.helix.enable = cfg.helix;
    home.packages = lib.mkIf cfg.rstudio [ pkgs.rstudio ];
    programs.vscode.enable = cfg.vscode;
    programs.zed-editor.enable = cfg.zed;
  };
}

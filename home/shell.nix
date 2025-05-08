{
  config,
  lib,
  pkgs,
  pkgs-unstable,
  ...
}:
let
  cfg = config.dawn.shell;
in
{
  options.dawn.shell = {
    fish = lib.mkEnableOption "fish";

    package = lib.mkOption {
      type = lib.types.package;
      default = if cfg.fish then config.programs.fish.package else pkgs.bash;
    };
  };

  config = {
    programs.fish = {
      enable = cfg.fish;
      package = pkgs-unstable.fish;
      interactiveShellInit = ''
        set -g fish_greeting
        set -g fish_cursor_default line
      '';
      shellAbbrs = {
        cat = "bat -p";
        ls = "eza";
      };
      shellAliases = {
        ll = "eza -la --icons --group-directories-first";
      };
    };

    programs.bat = {
      enable = true;
      config.theme = "GitHub";
    };
    home.sessionVariables.MANPAGER = ''
      sh -c 'sed -u -e \"s/\\x1B\[[0-9;]*m//g; s/.\\x08//g\" | bat -p -lman'
    '';

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
      config.global.hide_env_diff = true;
    };

    programs.eza.enable = true;

    programs.fd.enable = true;

    programs.fzf.enable = true;

    programs.ripgrep = {
      enable = true;
      arguments = [ "--no-require-git" ];
    };

    programs.zoxide = {
      enable = true;
      enableFishIntegration = cfg.fish;
    };

    home.packages = [
      pkgs.bintools
      pkgs.dust
      pkgs.just
      pkgs.jc
      pkgs.jq
      pkgs.glow
      pkgs.ouch
      pkgs.patchelf
      pkgs.tokei
      pkgs.wget
      pkgs.unzip
    ];
  };
}

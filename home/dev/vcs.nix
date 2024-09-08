{ config, lib, pkgs, ... }:
let
  cfg = config.vcs;
in
{
  options.vcs = {
    enable = lib.mkEnableOption "git and jujutsu";
    user = {
      name = lib.mkOption {
        type = lib.types.str;
      };
      email = lib.mkOption {
        type = lib.types.str;
      };
    };
  };

  config = {
    programs.git = {
      enable = true;
      userName = cfg.user.name;
      userEmail = cfg.user.email;
      ignores = ["/.direnv/" "/result" ".envrc" ];
      extraConfig = {
        core.editor = "${lib.getExe pkgs.helix}";
        init.defaultBranch = "main";
        push.autoSetupRemote = true;
        gpg.format = "ssh";
        user.signingKey = "${config.home.homeDirectory}/.ssh/id_ed25519.pub";
      };
      delta = {
        enable = true;
        options.syntax-theme = "GitHub";
      };
    };

    programs.jujutsu = {
      enable = true;
      settings = {
        user = { inherit (cfg.user) name email; };
        ui = {
          diff.tool = ["${lib.getExe pkgs.delta}" "$left" "$right"];
          editor = lib.getExe config.programs.helix.package;
        };
        signing = {
          sign-all = true;
          backend = "ssh";
          key = "${config.home.homeDirectory}/.ssh/id_ed25519.pub";
        };
      };
    };
  };
}

{
  config,
  lib,
  pkgs,
  pkgs-unstable,
  ...
}:
let
  cfg = config.dawn.vcs;
in
{
  options.dawn.vcs = {
    enable = lib.mkEnableOption "git and jujutsu";
    user = {
      name = lib.mkOption { type = lib.types.str; };
      email = lib.mkOption { type = lib.types.str; };
    };
  };

  config = {
    programs.git = {
      enable = cfg.enable;
      userName = cfg.user.name;
      userEmail = cfg.user.email;
      ignores = [
        ".direnv/"
        "/result"
        ".envrc"
      ];
      extraConfig = {
        core.editor = "${lib.getExe pkgs.helix}";
        init.defaultBranch = "trunk";
        push.autoSetupRemote = true;
        signing.format = "ssh";
        user.signingKey = "${config.home.homeDirectory}/.ssh/id_ed25519.pub";
      };
      difftastic = {
        enable = true;
        display = "inline";
      };
    };

    programs.jujutsu = {
      enable = cfg.enable;
      package = pkgs-unstable.jujutsu;
      settings = {
        user = { inherit (cfg.user) name email; };
        ui = {
          diff.tool = [
            "${lib.getExe pkgs.difftastic}"
            "$left"
            "$right"
            "--color=always"
            # "--display=inline"
          ];
          editor = lib.getExe config.programs.helix.package;
          merge-editor = "vscode";
        };
        signing = {
          backend = "ssh";
          key = "${config.home.homeDirectory}/.ssh/id_ed25519.pub";
        };
        git.sign-on-push = true;
      };
    };
  };
}

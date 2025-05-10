{
  config,
  lib,
  pkgs,
  util,
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
        user.signingKey = "${config.home.homeDirectory}/.ssh/id_ed25519_sk.pub";
      };
      difftastic = {
        enable = true;
        display = "inline";
      };
    };

    programs.jujutsu = {
      enable = cfg.enable;
      settings = {
        revsets.log = "present(@) | ancestors(immutable_heads().., 6) | present(trunk())";
        signing = {
          behavior = "own";
          backend = "ssh";
          backends.ssh.allowed-signers = pkgs.writeText "allowed-signers" ''
            ${config.programs.jujutsu.settings.user.email} ${util.ssh-keys.dawn-moonrise}
          '';
          key = "${config.home.homeDirectory}/.ssh/id_ed25519.pub";
        };
        ui = {
          default-command = ["log"];
          diff.tool = [
            "${lib.getExe pkgs.difftastic}"
            "$left"
            "$right"
            "--color=always"
          ];
          editor = lib.getExe config.programs.helix.package;
          merge-editor = "vscode";
          show-cryptographic-signatures = true;
        };
        user = { inherit (cfg.user) name email; };
      };
    };
  };
}

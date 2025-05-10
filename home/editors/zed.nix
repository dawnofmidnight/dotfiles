{ config, ... }:
{
  programs.zed-editor = {
    extensions = [
      # keep-sorted start
      "git-firefly"
      "github-theme"
      "make"
      "nix"
      "toml"
      # keep-sorted end
    ];

    userSettings = {
      # keep-sorted start block=yes
      assistant.enabled = false;
      auto_update = false;
      autosave.after_delay.milliseconds = 250;
      buffer_font_family = config.dawn.fonts.mono.name;
      buffer_font_size = 14;
      buffer_line_height.custom = 1.5;
      diagnostics.inline.enabled = true;
      features.copilot = false;
      icon_theme = {
        mode = "system";
        light = "Catppuccin Latte";
        dark = "Catppuccin Mocha";
      };
      inlay_hints.enabled = true;
      lsp.rust-analyzer.initialization_options.checkOnSave.command = "clippy";
      telemetry = {
        diagnostics = false;
        metrics = false;
      };
      terminal = {
        cursor_shape = "bar";
        line_height = "standard";
      };
      theme = {
        mode = "system";
        dark = "Github Dark";
        light = "Github Light";
      };
      ui_font_family = config.dawn.fonts.sans.name;
      wrap_guides = [ 80 ];
      # keep-sorted end
    };

    userKeymaps = [
      {
        context = "Editor";
        bindings.ctrl-s = "editor::Format";
      }
    ];
  };
}

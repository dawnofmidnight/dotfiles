{ pkgs-unstable, ... }: {
  programs.zed = {
    enable = true;
    package = pkgs-unstable.zed-editor;

    userSettings = {
      autosave.after_delay.milliseconds = 500;
      buffer_font_family = "IosevkaTerm Nerd Font";
      buffer_font_size = 14;
      ui_font_size = 16;
      load_direnv = "shell_hook";
      use_system_path_prompts = false;

      file_types.Fury = [ "fy" ];
      
      inlay_hints = {
        enabled = true;
        show_type_hints = true;
        show_parameter_hints = true;
        show_other_hints = true;
      };

      languages = {
        Fury = {
          tab_size = 4;
          language_servers = [ "fury" ];
        };
        Nix.tab_size = 2;
      };

      lsp.rust-analyzer = {
        binary.path_lookup = true;
        initialization_options.checkOnSave.command = "clippy";
      };

      telemetry = {
        diagnostics = false;
        metrics = false;
      };
    };
  };
}

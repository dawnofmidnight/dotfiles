{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfgLanguages = config.dawn.languages;

  tree-sitter-idris = pkgs.fetchFromGitHub {
    owner = "kayhide";
    repo = "tree-sitter-idris";
    rev = "c56a25cf57c68ff929356db25505c1cc4c7820f6";
    hash = "sha256-aOAxb0KjhSwlNX/IDvGwEysYvImgUEIDeNDOWRl1qNk=";
  };
in
{
  programs.helix = {
    defaultEditor = true;
    extraPackages = [
      pkgs.nixd
      pkgs.marksman
      pkgs.taplo
    ];
    ignores = config.programs.git.ignores;
    settings = {
      theme = "rose_pine_dawn_transparent";
      editor = {
        # keep-sorted start block=yes
        auto-save = {
          focus-lost = true;
          after-delay.enable = true;
        };
        bufferline = "always";
        color-modes = true;
        cursor-shape = {
          normal = "bar";
          insert = "bar";
          select = "bar";
        };
        file-picker.hidden = false;
        inline-diagnostics = {
          cursor-line = "hint";
          other-lines = "error";
        };
        line-number = "relative";
        lsp = {
          display-inlay-hints = true;
          display-progress-messages = true;
        };
        rulers = [ 80 ];
        soft-wrap.enable = true;
        true-color = true;
        # keep-sorted end
      };
    };

    themes.rose_pine_dawn_transparent = {
      inherits = "rose_pine_dawn";
      "ui.background" = { };
      "ui.background.separator" = { };
      "ui.statusline" = { };
      "ui.bufferline" = { };
      "ui.bufferline.background" = { };
    };

    languages = {
      grammar = [
        {
          name = "idris";
          source = {
            git = "https://github.com/kayhide/tree-sitter-idris";
            rev = "c56a25cf57c68ff929356db25505c1cc4c7820f6";
          };
        }
      ];

      language =
        [
          {
            name = "gas";
            indent = {
              tab-width = 4;
              unit = "    ";
            };
          }
          {
            name = "sql";
            indent = {
              tab-width = 4;
              unit = "    ";
            };
          }
        ]
        ++ lib.lists.optional cfgLanguages.nix {
          name = "nix";
          language-servers = [ (lib.getExe pkgs.nixd) ];
        };

      language-server.rust-analyzer.config.check.command = "clippy";
    };
  };

  xdg.configFile."helix/runtime/queries/idris" = {
    source = "${tree-sitter-idris}/queries";
    recursive = true;
  };
}

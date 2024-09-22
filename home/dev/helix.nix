{ lib, pkgs-unstable, ... }: {
  programs.helix = {
    enable = true;
    package = pkgs-unstable.helix;
    
    settings = {
      theme = "rose_pine_dawn";
      editor = {
        line-number = "relative";
        true-color = true;
        rulers = [ 80 ];
        bufferline = "always";
        color-modes = true;
        auto-save = {
          focus-lost = true;
          after-delay.enable = true;
        };
        lsp = {
          display-messages = true;
          display-inlay-hints = true;
        };
        cursor-shape = {
          normal = "bar";
          insert = "bar";
          select = "bar";
        };
      };
    };

    languages = {
      language = [
        {
          name = "nix";
          language-servers = [ (lib.getExe pkgs-unstable.nixd) ];
        }
        {
          name = "sql";
          indent = { tab-width = 4; unit = "  "; };
        }
      ];
    };
  };
}

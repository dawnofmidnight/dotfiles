{ lib, pkgs-unstable, ... }: {
  programs.vscode = {
    enable = true;
    package = pkgs-unstable.vscode;
    mutableExtensionsDir = false;
    
    extensions = (with pkgs-unstable.vscode-extensions; [
      catppuccin.catppuccin-vsc-icons
      jnoortheen.nix-ide
      mkhl.direnv
      ms-python.python
      ms-vscode.hexeditor
      mvllow.rose-pine
      rust-lang.rust-analyzer
      tamasfe.even-better-toml
      usernamehw.errorlens
    ]) ++ pkgs-unstable.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "lean4";
        publisher = "leanprover";
        version = "0.0.177";
        hash = "sha256-4roh1M5F4eIX0UNNDCfO47zgJAL+nRnHUAD///4hbok=";
      }
    ];

    userSettings = {
      "editor.fontFamily" = "monospace";
      "editor.fontLigatures" = true;
      "editor.formatOnPaste" = true;
      "editor.formatOnSave" = true;
      "editor.formatOnType" = true;
      "editor.rulers" = [ 80 ];
      "errorLens.borderRadius" = "4px";
      "errorLens.messageTemplate" = "$severity = $message";
      "errorLens.messageBackgroundMode" = "message";
      "errorLens.padding" = "2px 4px";
      "errorLens.replaceLinebreaksSymbol" = "\\";
      "errorLens.severityText" = [
        "error"
        "warning"
        "info"
        "hint"
      ];
      "files.autoSave" = "afterDelay";
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = lib.getExe pkgs-unstable.nixd;
      "workbench.colorTheme" = "Rosé Pine Dawn";
      "workbench.iconTheme" = "catppuccin-latte";
    };
  };
}

{
  lib,
  pkgs,
  pkgs-unstable,
  ...
}:
{
  programs.vscode = {
    package = pkgs-unstable.vscode;
    mutableExtensionsDir = true;

    extensions =
      (with pkgs-unstable.vscode-extensions; [
        # keep-sorted start
        catppuccin.catppuccin-vsc-icons
        github.github-vscode-theme
        github.vscode-github-actions
        gleam.gleam
        jnoortheen.nix-ide
        llvm-vs-code-extensions.vscode-clangd
        mkhl.direnv
        # ms-python.python
        ms-toolsai.jupyter
        ms-vscode.hexeditor
        mvllow.rose-pine
        myriad-dreamin.tinymist
        nefrob.vscode-just-syntax
        rust-lang.rust-analyzer
        tamasfe.even-better-toml
        thenuprojectcontributors.vscode-nushell-lang
        uiua-lang.uiua-vscode
        usernamehw.errorlens
        vscjava.vscode-java-pack
        # keep-sorted end
      ])
      ++ [
        (pkgs-unstable.vscode-utils.extensionFromVscodeMarketplace {
          name = "lean4";
          publisher = "leanprover";
          version = "0.0.194";
          hash = "sha256-zvr8cfZSO566MhIQ6K+ANC6EBZLWdOly8MDvgiKgyqo=";
        })
        (pkgs-unstable.vscode-utils.extensionFromVscodeMarketplace {
          name = "pest-ide-tools";
          publisher = "pest";
          version = "0.3.11";
          hash = "sha256-RU0LAuVYNynx0OFd7ID07t7bggGWzQNAZLRXMm+hnwE=";
        })
        (pkgs-unstable.vscode-utils.extensionFromVscodeMarketplace {
          name = "yuck";
          publisher = "eww-yuck";
          version = "0.0.3";
          hash = "sha256-DITgLedaO0Ifrttu+ZXkiaVA7Ua5RXc4jXQHPYLqrcM=";
        })
        (
          let
            pname = "idris2-lsp-vscode";
            publisher = "bamboo";
            version = "0.7.2";

            vsix = pkgs.buildNpmPackage rec {
              inherit pname version;
              src = pkgs.fetchFromGitHub {
                owner = publisher;
                repo = pname;
                rev = "1e9339224fbf4cc5b5d236e683c3285901b2faf3";
                hash = "sha256-v1fLMGmBNd7oiwW4RZcCMKpbt7BT+tryiDYs+Hqe5TE=";
              };
              npmDepsHash = "sha256-0XtsBsgHRwMEGsGpNYIVX44UiOaFFuLb0NWN3S7iOhA=";

              buildInputs = [
                pkgs.nodejs
                pkgs.libsecret
              ];
              nativeBuildInputs = [
                pkgs.pkg-config
                pkgs.vsce
              ];

              npmPackFlags = [ "--ignore-scripts" ];

              buildPhase = ''
                npm run compile
                npm run esbuild
                vsce package -o $pname.zip
              '';

              installPhase = ''
                mkdir $out
                cp $pname.zip $out
              '';
            };
          in
          pkgs-unstable.vscode-utils.buildVscodeExtension {
            inherit pname version vsix;
            src = "${vsix}/${pname}.zip";
            vscodeExtUniqueId = "${publisher}.${pname}";
            vscodeExtPublisher = publisher;
            vscodeExtName = pname;
            nativeBuildInputs = [ pkgs.pkg-config ];
          }
        )
      ];

    userSettings = {
      "editor.detectIndentation" = false;
      "editor.fontFamily" = "monospace";
      "editor.fontLigatures" = true;
      "editor.formatOnPaste" = true;
      "editor.formatOnSave" = true;
      "editor.formatOnType" = true;
      "editor.minimap.renderCharacters" = false;
      "editor.rulers" = [ 80 ];
      "editor.tabSize" = 4;
      "editor.wordWrap" = "on";

      "errorLens.borderRadius" = "4px";
      "errorLens.messageTemplate" = "$severity = $message";
      "errorLens.messageBackgroundMode" = "message";
      "errorLens.padding" = "2px 4px";
      "errorLens.replaceLinebreaksSymbol" = " \\ ";
      "errorLens.severityText" = [
        "error"
        "warning"
        "info"
        "hint"
      ];

      "explorer.confirmDelete" = false;
      "explorer.confirmDragAndDrop" = false;

      "extensions.ignoreRecommendations" = true;

      "files.autoSave" = "afterDelay";
      "files.exclude" = {
        "**/.direnv" = true;
        "**/.git" = true;
        "**/.jj" = true;
      };

      "workbench.colorTheme" = "GitHub Light Default";
      "workbench.iconTheme" = "catppuccin-latte";

      "[gleam]"."editor.tabSize" = 2;

      "[idris]"."editor.tabSize" = 2;

      "lean4.alwaysAskBeforeInstallingLeanVersions" = true;
      "lean4.automaticallyBuildDependencies" = true;

      "nix.enableLanguageServer" = true;
      "nix.serverPath" = lib.getExe pkgs-unstable.nixd;
      "[nix]"."editor.tabSize" = 2;

      "[pest]"."editor.formatOnSave" = false;

      "rust-analyzer.check.command" = "clippy";

      "[typst]"."editor.tabSize" = 2;

      "[uiua]"."editor.fontFamily" = "Uiua386, monospace";
    };
  };
}

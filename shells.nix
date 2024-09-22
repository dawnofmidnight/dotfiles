{ pkgs, pkgs-unstable }: {
  typst = pkgs.mkShell {
    buildInputs = with pkgs-unstable; [ typst typst-lsp ];
  };
}

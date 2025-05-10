{ pkgs }:
{
  typst = pkgs.mkShellNoCC {
    packages = [
      pkgs.tinymist
      pkgs.typst
    ];
  };

  idris2 = pkgs.mkShellNoCC {
    packages = [
      pkgs.chez
      pkgs.gmp
      pkgs.gnumake
      pkgs.idris2
      pkgs.idris2Packages.pack
      pkgs.pkg-config
      pkgs.rlwrap
    ];
  };
}

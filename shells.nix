{ pkgs, pkgs-unstable }:
{
  typst = pkgs.mkShellNoCC {
    packages = with pkgs-unstable; [
      typst
      tinymist
    ];
  };

  idris2 = pkgs.mkShellNoCC {
    packages = [
      pkgs-unstable.idris2
      pkgs-unstable.idris2Packages.pack
      pkgs.chez
      pkgs.gmp
      pkgs.gnumake
      pkgs.pkg-config
      pkgs.rlwrap
    ];
  };
}

final: prev:
{
  signal-desktop = (import ./signal-desktop.nix) final prev;
}
// import ../packages { pkgs = final; }

final: prev: {
  caddy = (import ./caddy.nix) final prev;
  signal-desktop = (import ./signal-desktop.nix) final prev;
}

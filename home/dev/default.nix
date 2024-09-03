{ pkgs, ... }: {
  imports = [
    ./helix.nix
    ./java.nix
    ./rust.nix
    ./vcs.nix
    ./vscode.nix
  ];

  home.packages = with pkgs; [ nixd ];
}

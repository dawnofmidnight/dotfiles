{ pkgs, ... }: {
  imports = [
    ./helix.nix
    ./java.nix
    ./rust.nix
    ./vcs.nix
    ./vscode.nix
    ./zed.nix
  ];

  home.packages = with pkgs; [ nixd ];
}

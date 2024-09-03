{ pkgs, ... }: {
  imports = [
    ./kitty.nix
    ./nushell
  ];

  programs.atuin = {
    enable = true;
    enableNushellIntegration = true;
  };

  programs.bat = {
    enable = true;
    config.theme = "GitHub";
  };

  programs.direnv = { 
    enable = true;
    nix-direnv.enable = true;
  };

  programs.fd.enable = true;

  programs.fzf.enable = true;

  programs.ripgrep.enable = true;

  programs.zoxide = {
    enable = true;
    enableNushellIntegration = true;
  };

  home.packages = with pkgs; [
    just
    numbat
    patchelf
    tokei
    wget
  ];
}

{ pkgs, ... }: {
  imports = [ ./nushell ];

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
    config.global.hide_env_diff = true;
  };

  programs.fd.enable = true;

  programs.fzf.enable = true;

  programs.kitty = {
    enable = true;
    font.name = "Iosevka";
    theme = "Rosé Pine Dawn";
  };

  programs.ripgrep = {
    enable = true;
    arguments = [ "--no-require-git" ];
  };

  programs.yazi = {
    enable = true;
    enableNushellIntegration = true;
  };
  
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

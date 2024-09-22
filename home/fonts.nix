{ pkgs, ... }: {
  home.packages = with pkgs; [
    crimson
    fira-sans
    libertine
    lmodern
    (nerdfonts.override { fonts = [ "Iosevka" "IosevkaTerm" ]; })
    noto-fonts-emoji
  ];

  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      serif = [ "Linux Libertine O" ];
      sansSerif = [ "Fira Sans" ];
      monospace = [ "Iosevka Nerd Font" ];
    };
  };
}

{ pkgs, ... }: {
  home.packages = with pkgs; [
    crimson
    fira-sans
    lmodern
    (nerdfonts.override { fonts = [ "Iosevka" "IosevkaTerm" ]; })
    noto-fonts-emoji
  ];

  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      serif = [ "Crimson" ];
      sansSerif = [ "Fira Sans" ];
      monospace = [ "Iosevka Nerd Font" ];
    };
  };
}
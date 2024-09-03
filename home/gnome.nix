{ pkgs, ... }: {
  home.packages = with pkgs; [
    gnomeExtensions.user-themes
  ];

  dconf.settings = {
    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = [ pkgs.gnomeExtensions.user-themes.extensionUuid ];
    };
  };
}

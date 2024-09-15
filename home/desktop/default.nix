{ config, lib, pkgs, ... }: {
  imports = [
    ./river.nix
    ./rofi.nix
    ./waybar.nix
    ./wlogout.nix
  ];

  home.pointerCursor = {
    package = pkgs.rose-pine-cursor;
    name = "BreezeX-RosePineDawn-Linux";
    size = 32;
    gtk.enable = true;
  };

  services.swayidle = {
    enable = true;
    timeouts = [
      { timeout = 300; command = "${lib.getExe config.programs.swaylock.package} -fF"; }
      { timeout = 450; command = "${lib.getExe' pkgs.systemd "systemctl"} suspend"; }
    ];
  };

  programs.swaylock = {
    enable = true;
    settings.image = "${./background-blurred.jpg}";
  };
}

{ config, lib, pkgs, ... }: {
  imports = [
    ./river.nix
    ./rofi.nix
    ./waybar.nix
    ./wlogout.nix
  ];

  home.pointerCursor = {
    package = pkgs.rose-pine-cursor;
    name = "BreezeX-RosePine-Linux";
    size = 32;
    gtk.enable = true;
    x11.enable = true;
  };

  services.swayidle = {
    enable = true;
    events = [
      { event = "before-sleep"; command = "${lib.getExe config.programs.swaylock.package} -fF"; }
    ];
    timeouts = [
      {
        timeout = 240;
        command = "${lib.getExe pkgs.brightnessctl} -s; ${lib.getExe pkgs.brightnessctl} set 0%";
        resumeCommand = "${lib.getExe pkgs.brightnessctl} -r";
      }
      { timeout = 300; command = "${lib.getExe config.programs.swaylock.package} -fF"; }
      { timeout = 450; command = "${lib.getExe' pkgs.systemd "systemctl"} suspend"; }
    ];
  };

  programs.swaylock = {
    enable = true;
    settings.image = "${./background-blurred.jpg}";
  };
}

{ config, lib, pkgs, ... }: {
  imports = [ 
    ./river.nix
    ./rofi.nix
    ./waybar.nix
    ./wlogout.nix
  ];

  services.swayidle = {
    enable = true;
    timeouts = [
      { timeout = 180; command = "${lib.getExe config.programs.swaylock.package} -fF"; }
      { timeout = 300; command = "${lib.getExe' pkgs.systemd "systemctl"} suspend"; }
    ];
  };

  programs.swaylock = {
    enable = true;
    settings.image = "${./background-blurred.jpg}";
  };
}

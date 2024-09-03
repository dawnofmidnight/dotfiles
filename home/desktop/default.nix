{ pkgs, ... }: {
  imports = [ 
    ./river.nix
    ./waybar.nix
  ];

  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland.override { plugins = [ pkgs.rofi-emoji ]; };
  };

  programs.wlogout.enable = true;

  # home.packages = with pkgs; [ pavucontrol ];

  # wayland.windowManager.sway = {
  #   enable = true;
  #   config = {
  #     input."1226:177:04CA00A0:00_04CA:00B1_Touchpad".tap = "enabled";
  #     output = {
  #       eDP-1.scale = "1.5";
  #       "*".bg = "${./background.jpg} fill";
  #     };

  #     modifier = "Mod4";

  #     terminal = "kitty";

  #     gaps = {
  #       inner = 10;
  #       outer = 10;
  #     };

  #     bars = [{ command = "${lib.getExe config.programs.waybar.package}"; }];
  #   };

  #   extraConfig = ''
  #     # Brightness
  #     bindsym XF86MonBrightnessDown exec light -U 10
  #     bindsym XF86MonBrightnessUp exec light -A 10

  #     # Volume
  #     bindsym XF86AudioRaiseVolume exec 'wpctl set-volume -l 1.0 @DEFAULT_SINK@ 1%+'
  #     bindsym XF86AudioLowerVolume exec 'wpctl set-volume -l 1.0 @DEFAULT_SINK@ 1%-'
  #     bindsym XF86AudioMute exec 'wpctl set-mute @DEFAULT_SINK@ toggle'
  #   '';
  # };

  # programs.swaylock = {
  #   enable = true;
  #   settings.image = "${./background-blurred.jpg}";
  # };

  # services.swayidle.enable = true;
}

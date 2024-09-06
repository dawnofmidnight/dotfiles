{ config, lib, pkgs, ... }:
let
  colors = (import ../../lib/colors.nix).rose-pine-dawn;
in {
  programs.wlogout = {
    enable = true;
    layout = [
      {
        label = "lock";
        action = lib.getExe config.programs.swaylock.package;
        text = "lock (l)";
        keybind = "l";
      }
      {
        label = "suspend";
        action = "${lib.getExe' pkgs.systemd "systemctl"} suspend";
        text = "suspend (u)";
        keybind = "u";
      }
      {
        label = "hibernate";
        action = "${lib.getExe' pkgs.systemd "systemctl"} hibernate";
        text = "hibernate (h)";
        keybind = "h";
      }
      {
        label = "logout";
        action = "loginctl terminate-user ${config.home.username}";
        text = "logout (e)";
        keybind = "e";
      }
      {
        label = "shutdown";
        action = "${lib.getExe' pkgs.systemd "systemctl"} poweroff";
        text = "shutdown (s)";
        keybind = "s";
      }
      {
        label = "reboot";
        action = "${lib.getExe' pkgs.systemd "systemctl"} reboot";
        text = "reboot (r)";
        keybind = "r";
      }
    ];

    style = ''
      * {
        background-image: none; 
      }
    
      window {
        background-image: image(url("${./background-blurred.jpg}"));
        font-family: monospace;
        font-size: 16px;
        font-weight: 500;
      }

      grid {
        margin: 250px 300px;
      }

      button {
        border: 1px solid ${colors.highlightHigh};
        border-radius: 16px;
        background: none;
        background-color: ${colors.base};
        padding: 16px;
      }

      button label {
        padding: 0;
        margin: 8px 0;
        border-image-width: 0;
      }

      button:hover {
        background-color: ${colors.overlay};
      }

      #lock      { color: ${colors.rose}; }
      #suspend   { color: ${colors.gold}; }
      #hibernate { color: ${colors.love}; }
      #logout    { color: ${colors.foam}; }
      #shutdown  { color: ${colors.iris}; }
      #reboot    { color: ${colors.pine}; }
    '';
  };
}

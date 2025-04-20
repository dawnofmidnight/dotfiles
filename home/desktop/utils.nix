{
  config,
  lib,
  pkgs,
  util,
  ...
}:
let
  cfg = config.dawn.desktop;
  enable = cfg.wm.which != null;
in
{
  options.dawn.desktop = {
    wallpaper = {
      regular = lib.options.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
      };
      blurred = lib.options.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
      };
    };
  };

  config = {
    home.packages = [ pkgs.wl-clipboard ];

    services.swayidle = {
      inherit enable;
      events = [
        {
          event = "before-sleep";
          command = "${lib.getExe config.programs.swaylock.package} -fF";
        }
      ];
      timeouts = [
        (
          if cfg.wm.which == "river" then
            {
              timeout = 240;
              command = "${lib.getExe pkgs.wlr-randr} --output eDP-1 --off";
              resumeCommand = "${lib.getExe pkgs.wlr-randr} --output eDP-1 --on";
            }
          else if cfg.wm.which == "niri" then
            {
              timeout = 240;
              command = "${lib.getExe config.programs.niri.package} msg action power-off-monitors";
              resumeCommand = "${lib.getExe config.programs.niri.package} msg action power-on-monitors";
            }
          else
            [ ]
        )
        {
          timeout = 450;
          command = "${lib.getExe' pkgs.systemd "systemctl"} suspend";
        }
        {
          timeout = 300;
          command = "${lib.getExe config.programs.swaylock.package} -fF";
        }
      ];
    };
    systemd.user.services.swayidle.Unit.After = lib.mkIf enable [ "graphical-session.target" ];

    programs.swaylock = {
      inherit enable;
      settings.image = "${cfg.wallpaper.blurred}";
    };

    programs.wlogout = {
      inherit enable;
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

      style =
        let
          colors = util.colors.rose-pine-dawn;
        in
        ''
          * {
            background-image: none;
          }

          window {
            background-image: image(url("${cfg.wallpaper.blurred}"));
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

    services.mako = {
      enable = enable;
      backgroundColor = "#7F6DA7AA";
      borderColor = "#413768";
      borderSize = 2;
    };

    # spaghetti wallpaper yoinked from https://www.artstation.com/artwork/ArwWzm
    systemd.user.services.wallpaper = lib.mkIf (enable && cfg.wallpaper.regular != null) {
      Unit = {
        PartOf = [ "graphical-session.target" ];
        Description = "Set wallpapers";
      };
      Install.WantedBy = [ "graphical-session.target" ];
      Service = {
        ExecStart = "${lib.getExe pkgs.swaybg} -i ${cfg.wallpaper.regular} -m fill";
        Restart = "on-failure";
        RestartSec = 1;
      };
    };
  };
}

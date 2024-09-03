{
  config,
  lib,
  pkgs,
  util,
  ...
}:
let
  cfg-wm = config.dawn.desktop.wm.which;
  colors = util.colors.rose-pine-dawn;
in
{
  programs.waybar = {
    enable = cfg-wm != null;

    settings = {
      bar = {
        layer = "top";
        modules-left =
          if cfg-wm == "niri" then
            [ "niri/workspaces" ]
          else if cfg-wm == "river" then
            [
              "river/mode"
              "river/tags"
            ]
          else
            [ ];
        modules-center =
          if cfg-wm == "niri" then
            [
              "niri/window"
              "mpris"
            ]
          else if cfg-wm == "river" then
            [
              "river/window"
              "mpris"
            ]
          else
            [ "mpris" ];
        modules-right = [
          "pulseaudio"
          "backlight"
          "network"
          "battery"
          "clock"
        ];

        "river/tags".num-tags = 4;

        "river/window".max-length = 50;

        mpris = {
          format = "{player_icon} {dynamic}";
          format-paused = "{status_icon} <i>{dynamic}</i>";
          dynamic-len = 30;
          player-icons.default = "▶";
          status-icons.default = "⏸";
        };

        pulseaudio = {
          format = "{icon} {volume}%";
          format-bluetooth = "{icon}   {volume}%";
          format-bluetooth-muted = "  {icon} ";
          format-muted = " {volume}%";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            default = [
              ""
              ""
              " "
            ];
          };
          on-click = lib.getExe pkgs.pwvucontrol;
          on-click-right = lib.getExe' pkgs.blueman "blueman-manager";
        };

        backlight = {
          format = "{icon} {percent}%";
          format-icons = [
            ""
            ""
            ""
            ""
            ""
            ""
            ""
            ""
            ""
          ];
        };

        network = {
          format-wifi = "  {essid} ({signalStrength}%)";
          format-ethernet = "  {ipaddr}/{cidr}";
          format-linked = "  {ifname} (No IP)";
          format-disconnected = "⚠ Disconnected";
          tooltip-format = "{ifname} ({ipaddr}/{cidr}) via {gwaddr}";
        };

        battery = {
          format = "{icon}  {capacity}%";
          format-charging = " {capacity}%";
          format-icons = [
            ""
            ""
            ""
            ""
            ""
          ];
        };

        clock.format = "{:%a %F %R}";
      };
    };

    style = ''
      * {
        font-size: 14px;
        font-family: monospace;
      }

      window#waybar {
        background: transparent;
      }

      #mode, #workspaces { margin-left:  16px; margin-right: 8px; }
      #clock             { margin-right: 16px;                    }

      .module {
        background-color: ${colors.base};
        border: 1px solid ${colors.highlightHigh};
        border-radius: 8px;
        padding: 0 16px;
        margin: 8px 4px 0;
        color: ${colors.text};
      }

      window#waybar.empty #window {
        background-color: transparent;
        border: none;
      }

      #tags {
        margin-left: 0;
        margin-right: 0;
      }

      #tags button, #workspaces button {
        border: none;
        color: ${colors.text};
        margin: 0 4px;
      }

      #tags button:hover, #workspaces button:hover {
        background: none;
        border: none;
        box-shadow: none;
        text-shadow: none;
        background-color: ${colors.overlay};
      }

      #tags button.occupied {
        background-color: ${colors.rose};
      }

      #tags button.occupied:hover {
        background-color: ${colors.highlightHigh};
      }

      #tags button.focused, #workspaces button.active {
        background-color: ${colors.rose};
        color: ${colors.base};
      }

      #tags button.focused:hover, #workspaces button.active:hover {
        background-color: #e37a76;
      }

      #workspaces button.empty {
        color: ${colors.muted};
      }

      #workspaces button.active.empty {
        color: ${colors.muted};
        background-color: ${colors.rose};
      }

      #tags button:first-child, #workspaces button:first-child { margin-left:  0; }
      #tags button:last-child,  #workspaces button:last-child  { margin-right: 0; }

      #pulseaudio { color: ${colors.foam}; }
      #backlight  { color: ${colors.pine}; }
      #network    { color: ${colors.iris}; }
      #battery    { color: ${colors.love}; }
      #clock      { color: ${colors.rose}; }
    '';
  };
}

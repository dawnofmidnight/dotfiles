{ pkgs-unstable, util, ... }:
let
  colors = util.colors.rose-pine-dawn;
in {
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    
    settings = {
      bar = {
        layer = "top";
        modules-left = [ "river/mode" "river/tags" ];
        modules-center = [ "river/window" ];
        modules-right = [ "pulseaudio" "backlight" "network" "battery" "clock" ];

        "river/tags".num-tags = 5;
        
        "river/window".max-length = 100;
        
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
            default = [ "" "" "" ];
          };
          on-click = "pavucontrol";
        };

        backlight = {
          format = "{icon} {percent}%";
          format-icons = [ "" "" "" "" "" "" "" "" "" ];
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
          format-icons = [ "" "" "" "" "" ];
        };
        
        clock.format = "{:%a %F %R}";
      };
    };

    style = ''
      * {
        font-family: monospace;
      }

      window#waybar {
        background: transparent;
      }

      #mode  { margin-left:  12px; margin-right: 8px; }
      #clock { margin-right: 12px; }

      .module {
        background-color: ${colors.base};
        border: 1px solid ${colors.highlightHigh};
        border-radius: 8px;
        padding: 0 16px;
        margin: 6px 4px 0 4px;
        color: ${colors.text};
      }

      #tags {
        margin-left: 0;
        margin-right: 0;
      }

      #tags button {
        border: none;
        margin: 0 4px;
      }

      #tags button:hover {
        background: none;
        border: none;
        box-shadow: none;
        text-shadow: none;
        background-color: #f2e9e1;
      }

      #tags button.occupied {
        background-color: #ebbcba;
      }

      #tags button.occupied:hover {
        background-color: #df9695; 
      }

      #tags button.focused {
        background-color: #b4637a; 
        color: #faf4ed;
      }

      #tags button.focused:hover {
        background-color: #9b4b60;
      }

      #tags button:first-child { margin-left: 0; }
      #tags button:last-child { margin-right: 0; }

      #clock      { color: ${colors.rose}; }
      #battery    { color: ${colors.love}; }
      #network    { color: ${colors.iris}; }
      #backlight  { color: ${colors.pine}; }
      #pulseaudio { color: ${colors.foam}; }
    '';
  };
}

{
  programs.waybar = {
    enable = true;
    systemd.enable = true;

    settings = {
      bar = {
        layer = "top";
        modules-left = [ "river/mode" "river/tags" ];
        modules-center = [ "river/window" ];
        modules-right = [ "pulseaudio" "backlight" "network" "battery" "clock" ];

        "river/tags".num-tags = 4;
        
        pulseaudio = {
          format = "{icon} {volume}% {format_source}";
          format-bluetooth = "{icon} {volume}% {format_source}";
          format-bluetooth-muted = " {icon} {format_source}";
          format-muted = " {format_source}";
          format-source = "{volume}% ";
          format-source-muted = "";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            default = ["" "" "" ];
          };
          on-click = "pavucontrol";
        };

        backlight = {
          format = "{icon} {percent}%";
          format-icons = [ "" "" "" "" "" "" "" "" "" ];
        };

        network = {
          format-wifi = " {essid} ({signalStrength}%)";
          format-ethernet = " {ipaddr}/{cidr}";
          format-linked = "  {ifname} (No IP)";
          format-disconnected = "⚠ Disconnected";
          format-alt = "{ifname}: {ipaddr}/{cidr}";
          tooltip-format = " {ifname} via {gwaddr}";
        };
        
        battery = {
          format = "{icon} {capacity}%";
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

      #mode {
        margin-left: 10px;
      }

      #clock {
        margin-right: 10px;
      }

      .module {
        background-color: #faf4ed;
        border: 1px solid #cecacd;
        border-radius: 8px;
        padding: 0 16px;
        margin: 6px 4px 0 4px;
        color: #575279;
      }

      #tags button {
        margin: 0 4px;
      }

      #tags button.occupied {
        background-color: #dfdad9;
        color: #575279;
      }
      
      #tags button.focused {
        background-color: #b4637a; 
        color: white;
      }

      #clock {
        color: #d7827e;
      }

      #battery {
        color: #b4637a;
      }

      #network {
        color: #907aa9;
      }

      #backlight {
        color: #286983;
      }

      #pulseaudio {
        color: #56949f;
      }
    '';
  };
}

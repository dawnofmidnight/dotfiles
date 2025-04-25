{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [ inputs.niri.homeModules.niri ];

  programs.niri = lib.mkIf (config.dawn.desktop.wm.which == "niri") {
    # TODO: screenshot show-pointer is needed; get rid of this after v25.02
    package = pkgs.niri-unstable;

    settings = {
      environment = {
        DISPLAY = ":0";
        ELECTRON_OZONE_PLATFORM_HINT = "auto";
        NIXOS_OZONE_WL = "1";
      };

      input = {
        touchpad = {
          click-method = "clickfinger";
          dwt = true;
          scroll-method = "two-finger";
          tap-button-map = "left-right-middle";
          natural-scroll = false;
        };
        touch.map-to-output = "eDP-1";
        focus-follows-mouse.enable = true;
      };

      outputs = {
        "eDP-1" = {
          scale = 1.5;
          position = {
            x = 0;
            y = 0;
          };
        };
      };

      hotkey-overlay.skip-at-startup = true;
      prefer-no-csd = true;
      spawn-at-startup =
        [
          { command = [ (lib.getExe inputs.niri.packages.${pkgs.system}.xwayland-satellite-stable) ]; }
          { command = [ (lib.getExe config.programs.waybar.package) ]; }
        ]
        ++ lib.lists.optional config.dawn.communication.thunderbird { command = [ "thunderbird" ]; }
        ++ lib.lists.optional config.dawn.communication.signal { command = [ "signal-desktop" ]; };
      screenshot-path = "${config.home.homeDirectory}/screenshots/screenshot_%Y-%m-%d_%H:%M:%S.png";

      layout =
        let
          preset-increments = map (n: { proportion = n / 10.0; }) (lib.lists.range 3 8);
        in
        {
          border = {
            enable = true;
            width = 2.5;
            active.color = "#ffafcc";
            inactive.color = "#cdb4db";
          };
          focus-ring.enable = false;
          preset-column-widths = preset-increments;
          preset-window-heights = preset-increments;
          tab-indicator = {
            enable = true;
            gaps-between-tabs = 10.0;
          };
        };

      workspaces.bg.open-on-output = "HDMI-A-1";

      window-rules = [
        {
          geometry-corner-radius =
            let
              radius = 4.0;
            in
            {
              bottom-left = radius;
              bottom-right = radius;
              top-left = radius;
              top-right = radius;
            };
          clip-to-geometry = true;
        }
        {
          matches = [ { app-id = "(signal|thunderbird)"; } ];
          open-on-workspace = "bg";
        }
        {
          matches = [
            { app-id = "(" + (builtins.concatStringsSep "|" config.dawn.terminal.app-ids) + "|obsidian)"; }
          ];
          default-column-width.proportion = 4.0 / 10.0;
        }
        {
          matches = [ { app-id = "com.mitchellh.ghostty"; } ];
          draw-border-with-background = false;
        }
      ];

      binds =
        let
          mod = "Mod";
          shift = "Shift";
          ctrl = "Ctrl";
          alt = "Alt";
          bindFull = mods: key: action: args: extra: {
            name = "${if builtins.length mods != 0 then lib.concatStringsSep "+" mods + "+" else ""}${key}";
            value = {
              action.${action} = args;
            } // extra;
          };
          bind =
            mods: key: action:
            bindFull mods key action { } { };
          bindHorizontal = mods: action: [
            (bind mods "Left" (builtins.replaceStrings [ "$" ] [ "left" ] action))
            (bind mods "Right" (builtins.replaceStrings [ "$" ] [ "right" ] action))
            (bind mods "H" (builtins.replaceStrings [ "$" ] [ "left" ] action))
            (bind mods "L" (builtins.replaceStrings [ "$" ] [ "right" ] action))
          ];
          bindVertical = mods: action: [
            (bind mods "Up" (builtins.replaceStrings [ "$" ] [ "up" ] action))
            (bind mods "Down" (builtins.replaceStrings [ "$" ] [ "down" ] action))
            (bind mods "K" (builtins.replaceStrings [ "$" ] [ "up" ] action))
            (bind mods "J" (builtins.replaceStrings [ "$" ] [ "down" ] action))
          ];
          bindDigits =
            mods: action:
            map (digit: bindFull mods (builtins.toString digit) action digit { }) (lib.lists.range 1 9);
        in
        builtins.listToAttrs (
          lib.lists.flatten [
            (bind [ mod ] "Q" "close-window")
            (bind [ mod ] "Slash" "show-hotkey-overlay")
            (bind [ mod shift ] "E" "quit")

            (bindFull [ mod ] "Return" "spawn" (lib.getExe config.dawn.terminal.default.package) { })
            (bindFull [ mod ] "Space" "spawn" (lib.getExe config.dawn.launcher.package) { })
            (bindFull [ mod ] "Z" "spawn" [
              (lib.getExe config.programs.wlogout.package)
              "-r"
              "32"
              "-c"
              "32"
            ] { })

            (bindHorizontal [ mod ] "focus-column-or-monitor-$")
            (bindVertical [ mod ] "focus-window-or-workspace-$")
            (bindDigits [ mod ] "focus-workspace")
            (bindHorizontal [ mod ctrl ] "move-column-$-or-to-monitor-$")
            (bindDigits [ mod ctrl ] "move-column-to-workspace")
            (bindVertical [ mod ctrl ] "move-column-to-workspace-$")
            (bindHorizontal [ mod ctrl alt ] "move-window-to-monitor-$")
            (bindVertical [ mod ctrl alt ] "move-window-$-or-to-workspace-$")
            (bindDigits [ mod ctrl alt ] "move-window-to-workspace")
            (bindHorizontal [ mod shift ] "focus-monitor-$")
            (bindVertical [ mod shift ] "focus-workspace-$")
            (bindHorizontal [ mod ctrl shift ] "move-workspace-to-monitor-$")
            (bindVertical [ mod ctrl shift ] "move-workspace-$")

            (bindFull [ mod ] "WheelScrollUp" "focus-workspace-up" { } { cooldown-ms = 150; })
            (bindFull [ mod ] "WheelScrollDown" "focus-workspace-down" { } { cooldown-ms = 150; })
            (bindFull [ mod ctrl ] "WheelScrollUp" "move-column-to-workspace-up" { } { cooldown-ms = 150; })
            (bindFull [ mod ctrl ] "WheelScrollDown" "move-column-to-workspace-down" { } { cooldown-ms = 150; })

            (bindFull [ mod shift ] "WheelScrollUp" "focus-column-left" { } { cooldown-ms = 150; })
            (bindFull [ mod shift ] "WheelScrollDown" "focus-column-right" { } { cooldown-ms = 150; })
            (bindFull [ mod shift ctrl ] "WheelScrollUp" "move-column-left" { } { cooldown-ms = 150; })
            (bindFull [ mod shift ctrl ] "WheelScrollDown" "move-column-right" { } { cooldown-ms = 150; })

            (bind [ mod ] "WheelScrollRight" "focus-column-right")
            (bind [ mod ] "WheelScrollLeft" "focus-column-left")
            (bind [ mod ctrl ] "WheelScrollRight" "move-column-right")
            (bind [ mod ctrl ] "WheelScrollLeft" "move-column-left")

            (bind [ mod ] "BracketLeft" "consume-or-expel-window-left")
            (bind [ mod ] "BracketRight" "consume-or-expel-window-right")

            (bindFull [ mod ] "Minus" "set-column-width" "-5%" { })
            (bindFull [ mod ] "Equal" "set-column-width" "+5%" { })
            (bindFull [ mod shift ] "Minus" "set-window-height" "-5%" { })
            (bindFull [ mod shift ] "Equal" "set-window-height" "+5%" { })

            (bind [ mod ] "R" "switch-preset-column-width")
            (bind [ mod shift ] "R" "switch-preset-window-height")
            (bind [ mod ] "F" "maximize-column")
            (bind [ mod shift ] "F" "fullscreen-window")
            (bind [ mod ] "C" "center-column")
            (bind [ mod ] "V" "toggle-window-floating")
            (bind [ mod shift ] "V" "switch-focus-between-floating-and-tiling")
            (bind [ mod ] "W" "toggle-column-tabbed-display")

            (bindFull [ ] "Print" "screenshot" { show-pointer = false; } { })
            (bind [ ctrl ] "Print" "screenshot-window")
            (bind [ alt ] "Print" "screenshot-screen")

            (bindFull [ ] "XF86AudioRaiseVolume" "spawn" [
              (lib.getExe' pkgs.wireplumber "wpctl")
              "set-volume"
              "-l"
              "1.0"
              "@DEFAULT_SINK@"
              "1%+"
            ] { allow-when-locked = true; })
            (bindFull [ ] "XF86AudioLowerVolume" "spawn" [
              (lib.getExe' pkgs.wireplumber "wpctl")
              "set-volume"
              "-l"
              "1.0"
              "@DEFAULT_SINK@"
              "1%-"
            ] { allow-when-locked = true; })
            (bindFull [ ] "XF86AudioMute" "spawn" [
              (lib.getExe' pkgs.wireplumber "wpctl")
              "set-mute"
              "@DEFAULT_SINK@"
              "toggle"
            ] { allow-when-locked = true; })
            (bindFull [ ] "XF86MonBrightnessUp" "spawn" [ (lib.getExe pkgs.brightnessctl) "set" "1%+" ] {
              allow-when-locked = true;
            })
            (bindFull [ ] "XF86MonBrightnessDown" "spawn" [ (lib.getExe pkgs.brightnessctl) "set" "1%-" ] {
              allow-when-locked = true;
            })
          ]
        );
    };
  };
}

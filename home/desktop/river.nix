{
  config,
  lib,
  pkgs,
  ...
}:
{
  home.packages = lib.mkIf config.wayland.windowManager.river.enable [
    pkgs.pwvucontrol
    pkgs.slurp
    pkgs.wayshot
    pkgs.wl-clipboard
    pkgs.wl-screenrec
    pkgs.wlr-randr
    (pkgs.writeShellApplication {
      name = "river-refresh";
      runtimeInputs = with pkgs; [ bash ];
      text = "bash ${config.xdg.configFile."river/init".source}";
    })
  ];

  wayland.windowManager.river = {
    settings =
      let
        mod = "Super";
        shift = "Shift";
        ctrl = "Control";
        alt = "Alt";
        bind = mods: key: command: {
          name = "${if builtins.length mods != 0 then lib.concatStringsSep "+" mods else "None"} ${key}";
          value = command;
        };
        pow2 =
          n:
          if n == 1 then
            2
          else if n == 0 then
            1
          else
            2 * pow2 (n - 1);
      in
      {
        default-layout = "rivertile";

        spawn = [
          "'${lib.getExe pkgs.wlr-randr} --output eDP-1 --scale 1.5'"
          "rivertile"
        ];

        border-color-focused = "0xb4637a";
        border-color-unfocused = "0xebbcba";

        # mostly derived from https://codeberg.org/river/river/src/branch/master/example/init
        map.normal = builtins.listToAttrs (
          lib.lists.flatten [
            (bind [ mod ] "Return" "spawn ${lib.getExe config.programs.kitty.package}")
            (bind [ mod ] "space" "spawn '${lib.getExe config.programs.rofi.package} -show drun'")
            (bind [ mod shift ] "space" "spawn '${lib.getExe config.programs.rofi.package} -show run'")
            (bind [ mod ] "z" "spawn '${lib.getExe config.programs.wlogout.package} -r 32 -c 32'")
            (bind [ mod ] "s" ''spawn '${lib.getExe pkgs.wayshot} - -s | wl-copy' '')

            (bind [ mod ] "q" "close")

            (bind [ mod ] "j" "focus-view next")
            (bind [ mod ] "k" "focus-view previous")

            (bind [ mod shift ] "j" "swap next")
            (bind [ mod shift ] "k" "swap previous")

            (bind [ mod ] "Period" "focus-output next")
            (bind [ mod ] "Comma" "focus-output previous")

            (bind [ mod shift ] "Period" "send-to-output next")
            (bind [ mod shift ] "Comma" "send-to-output previous")

            (bind [ mod ] "Return" "zoom")

            (bind [ mod ] "h" "send-layout-cmd rivertile 'main-ratio -0.05'")
            (bind [ mod ] "l" "send-layout-cmd rivertile 'main-ratio +0.05'")

            (bind [ mod shift ] "h" "send-layout-cmd rivertile 'main-count +1'")
            (bind [ mod shift ] "l" "send-layout-cmd rivertile 'main-count -1'")

            (bind [ mod alt ] "h" "move left 100")
            (bind [ mod alt ] "j" "move down 100")
            (bind [ mod alt ] "k" "move up 100")
            (bind [ mod alt ] "l" "move right 100")

            (bind [ mod alt ctrl ] "h" "snap left")
            (bind [ mod alt ctrl ] "j" "snap down")
            (bind [ mod alt ctrl ] "k" "snap up")
            (bind [ mod alt ctrl ] "l" "snap right")

            (bind [ mod alt shift ] "h" "resize horizontal -100")
            (bind [ mod alt shift ] "j" "resize vertical 100")
            (bind [ mod alt shift ] "k" "resize vertical -100")
            (bind [ mod alt shift ] "l" "resize horizontal 100")

            # tags
            (
              let
                n' = n: toString (pow2 (n - 1));
                range = lib.range 1 9;
              in
              [
                (map (n: (bind [ mod ] "${toString n}" "set-focused-tags ${n' n}")) range)
                (map (n: (bind [ mod shift ] "${toString n}" "set-view-tags ${n' n}")) range)
                (map (n: (bind [ mod ctrl ] "${toString n}" "toggle-focused-tags ${n' n}")) range)
                (map (n: (bind [ mod shift ctrl ] "${toString n}" "toggle-view-tags ${n' n}")) range)
              ]
            )
            (
              let
                allTags = toString (pow2 32 - 1);
                scratchTag = toString (pow2 31);
              in
              [
                (bind [ mod ] "0" "set-focused-tags ${allTags}")
                (bind [ mod shift ] "0" "set-view-tags ${allTags}")

                (bind [ mod ] "p" "toggle-focused-tags ${scratchTag}")
                (bind [ mod shift ] "p" "set-view-tags ${scratchTag}")
              ]
            )

            (bind [ mod ] "f" "toggle-float")
            (bind [ mod shift ] "f" "toggle-fullscreen")

            (bind [ mod ] "up" "send-layout-cmd rivertile 'main-location top'")
            (bind [ mod ] "right" "send-layout-cmd rdivertile 'main-location right'")
            (bind [ mod ] "down" "send-layout-cmd rivertile 'main-location bottom'")
            (bind [ mod ] "left" "send-layout-cmd rivertile 'main-location left'")
          ]
        );

        map."-repeat".normal = builtins.listToAttrs [
          (bind [ ] "XF86AudioRaiseVolume"
            "spawn '${lib.getExe' pkgs.wireplumber "wpctl"} set-volume -l 1.0 @DEFAULT_SINK@ 1%+'"
          )
          (bind [ ] "XF86AudioLowerVolume"
            "spawn '${lib.getExe' pkgs.wireplumber "wpctl"} set-volume -l 1.0 @DEFAULT_SINK@ 1%-'"
          )
          (bind [ ] "XF86AudioMute"
            "spawn '${lib.getExe' pkgs.wireplumber "wpctl"} set-mute @DEFAULT_SINK@ toggle'"
          )

          (bind [ ] "XF86MonBrightnessUp" "spawn '${lib.getExe pkgs.brightnessctl} set 1%+'")
          (bind [ ] "XF86MonBrightnessDown" "spawn '${lib.getExe pkgs.brightnessctl} set 1%-'")
        ];

        map-pointer.normal = builtins.listToAttrs (
          lib.lists.flatten [
            (bind [ mod ] "BTN_LEFT" "move-view")
            (bind [ mod ] "BTN_RIGHT" "resize-view")
            (bind [ mod ] "BTN_MIDDLE" "toggle-float")
          ]
        );

        rule-add."-app-id" = {
          "Eclipse" = "ssd";
          "firefox" = "ssd";
          "google-chrome" = "ssd";
          "librewolf" = "ssd";
          "obsidian" = "ssd";
          "thunderbird" = "ssd";
        };
      };
    extraConfig = ''
      riverctl input touch-1267-16981-ELAN9020:00_04F3:4255 map-to-output eDP-1
      riverctl input pointer-1226-177-04CA00A0:00_04CA:00B1_Touchpad tap enabled
    '';
  };
}

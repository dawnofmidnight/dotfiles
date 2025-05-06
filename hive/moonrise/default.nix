{
  config,
  inputs,
  pkgs,
  pkgs-unstable,
  ...
}:
{
  imports = [
    ./core.nix
    ./hardware-configuration.nix
    ./services.nix
  ];

  environment.systemPackages = [
    inputs.agenix.packages.${pkgs.system}.default
    pkgs.brightnessctl
    pkgs.man-pages
    pkgs.man-pages-posix
    pkgs-unstable.sbctl
  ];

  documentation = {
    dev.enable = true;
    man = {
      enable = true;
      generateCaches = false;
    };
    nixos.enable = false;
  };

  home-manager.users.dawn = {
    dawn = {
      # keep-sorted start block=yes
      audio = true;
      browsers = {
        chromium = true;
        librewolf = true;
      };
      communication = {
        signal = true;
        thunderbird = true;
      };
      desktop = {
        theme = {
          cursor = {
            package = pkgs.rose-pine-cursor;
            name = "BreezeX-RosePineDawn-Linux";
          };
        };
        wallpaper = {
          regular = ./wallpapers/plinkscape.png;
          blurred = ./wallpapers/plinkscape-blurred.png;
        };
        wm.which = "niri";
      };
      editors = {
        helix = true;
        rstudio = true;
        vscode = true;
        zed = true;
      };
      fonts = {
        sans = {
          package = pkgs.fira-sans;
          name = "Fira Sans";
        };
        serif = {
          package = pkgs.libertinus;
          name = "Libertinus Serif";
        };
        mono = {
          package = pkgs-unstable.nerd-fonts.iosevka-term;
          name = "IosevkaTerm Nerd Font";
        };
        extra = [
          pkgs.crimson
          pkgs.lmodern
          pkgs.noto-fonts-emoji
          pkgs.uiua386
        ];
      };
      languages = {
        nix = true;
        rust = true;
      };
      launcher.which = "fuzzel";
      shell = {
        fish = true;
        nu = true;
        default.which = "fish";
      };
      terminal = {
        ghostty = true;
        default.which = "ghostty";
      };
      vcs.enable = true;
      # keep-sorted end
    };

    xdg = {
      enable = true;
      userDirs = {
        download = config.users.users.dawn.home + "/downloads";
        music = config.users.users.dawn.home + "/music";
        pictures = config.users.users.dawn.home + "/pictures";
        videos = config.users.users.dawn.home + "/videos";
      };
    };

    home.packages = [
      # keep-sorted start
      pkgs-unstable.libreoffice-fresh
      pkgs-unstable.obsidian
      pkgs-unstable.yt-dlp
      pkgs-unstable.yubioath-flutter
      pkgs.amfora
      pkgs.cavalier
      pkgs.foliate
      pkgs.hunspell
      pkgs.hunspellDicts.en_US
      pkgs.libqalculate
      pkgs.mpv
      pkgs.nautilus
      pkgs.numbat
      pkgs.picard
      pkgs.qalculate-gtk
      pkgs.sage
      pkgs.sioyek
      pkgs.vlc
      # keep-sorted end
    ];
  };

  # zed needs this. cosmic-text can't read the way home-manager handles fonts.
  # https://github.com/zed-industries/zed/issues/18982
  fonts.packages =
    let
      fc = config.home-manager.users.dawn.dawn.fonts;
    in
    [
      fc.sans.package
      fc.serif.package
      fc.mono.package
    ]
    ++ fc.extra;
}

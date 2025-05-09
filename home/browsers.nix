{
  config,
  lib,
  pkgs-unstable,
  ...
}:
let
  cfg = config.dawn.browsers;
in
{
  options.dawn.browsers = {
    chromium = lib.mkEnableOption "ungoogled-chromium";
    librewolf = lib.mkEnableOption "librewolf";
  };

  config = {
    programs.chromium = {
      enable = cfg.chromium;
      package = pkgs-unstable.ungoogled-chromium;
      extensions = [
        { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # ublock origin
        { id = "clngdbkpkpeebahjckkjfobafhncgmne"; } # stylus
        { id = "nngceckbapebfimnlniiiahkandclblb"; } # bitwarden
      ];
    };

    programs.librewolf = {
      enable = cfg.librewolf;
      package = pkgs-unstable.librewolf;
      profiles.dawn = {
        containers = {
          dawn = {
            id = 1;
            icon = "fingerprint";
            color = "pink";
          };
          dusk = {
            id = 2;
            icon = "fingerprint";
            color = "purple";
          };
          ncsu = {
            id = 3;
            icon = "fingerprint";
            color = "blue";
          };
          lr = {
            id = 4;
            icon = "fingerprint";
            color = "turquoise";
          };
        };
        containersForce = true;
        search = {
          force = true;
          default = "ddg";
          privateDefault = "ddg";
          engines = {
            ddg = {
              urls = [
                {
                  template = "https://duckduckgo.com/?q={searchTerms}&kbg=-1&kbe=0&kau=-1&kao=-1&kap=-1&kaq=-1&kax=-1&kak=-1";
                }
              ];
              iconUpdateURL = "https://duckduckgo.com/favicon.ico";
              updateInterval = 7 * 24 * 60 * 60 * 1000;
              definedAliases = [
                "@duckduckgo"
                "@ddg"
              ];
            };
            # get rid of all the random engines librewolf adds
            "Bing".metaData.hidden = true;
            "DuckDuckGo".metaData.hidden = true;
            "DuckDuckGo Lite".metaData.hidden = true;
            "Google".metaData.hidden = true;
            "MetaGer".metaData.hidden = true;
            "Mojeek".metaData.hidden = true;
            "SearXNG - searx.be".metaData.hidden = true;
            "StartPage".metaData.hidden = true;
            "Wikipedia (en)".metaData.hidden = true;
          };
        };
        settings = {
          # keep-sorted start block=yes
          "browser.display.use_document_fonts" = 0;
          "browser.eme.ui.enabled" = false; # stop asking to enable DRM
          "browser.search.separatePrivateDefault" = false;
          "browser.startup.page" = 3;
          "browser.tabs.groups.enabed" = true;
          "font.default.x-western" = "sans-serif";
          "privacy.donottrackheader.enabled" = true;
          "privacy.resistFingerprinting" = false;
          "sidebar.verticalTabs" = true;
          # keep-sorted end
        };
      };
      policies = {
        ExtensionSettings = {
          # keep-sorted start block=yes
          "FirefoxColor@mozilla.com" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/firefox-color/latest.xpi";
            installation_mode = "force_installed";
          };
          "firefox.container-shortcuts@strategery.io" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/easy-container-shortcuts/latest.xpi";
            installation_mode = "force_installed";
          };
          "github-no-more@ihatereality.space" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/github-no-more/latest.xpi";
            installation_mode = "force_installed";
          };
          "sponsorBlocker@ajay.app" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/sponsorblock/latest.xpi";
            installation_mode = "force_installed";
          };
          "uBlock0@raymondhill.net" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
            installation_mode = "force_installed";
          };
          "wayback_machine@mozilla.org" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/wayback-machine_new/latest.xpi";
            installation_mode = "force_installed";
          };
          "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
            installation_mode = "force_installed";
          };
          "{7a7a4a92-a2a0-41d1-9fd7-1e92480d612d}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/styl-us/latest.xpi";
            installation_mode = "force_installed";
          };
          # keep-sorted end
        };
      };
    };
  };
}

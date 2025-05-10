{
  config,
  lib,
  pkgs,
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
      package = pkgs.ungoogled-chromium;
      commandLineArgs = [
        "--extension-mime-request-handling=always-prompt-for-install"
        "--show-avatar-button=incognito-and-guest"
        "--remove-tabsearch-button"
        "--custom-ntp=https://start.duckduckgo.com"
      ];
      extensions = [
        { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # ublock origin
        { id = "clngdbkpkpeebahjckkjfobafhncgmne"; } # stylus
        { id = "nngceckbapebfimnlniiiahkandclblb"; } # bitwarden
      ];
    };

    programs.librewolf = {
      enable = cfg.librewolf;
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
          default = "ddg-preconfigured";
          privateDefault = "ddg-preconfigured";
          engines = {
            ddg-preconfigured = {
              definedAliases = [
                "@duckduckgo"
                "@ddg"
              ];
              icon = pkgs.fetchurl {
                url = "https://duckduckgo.com/favicon.ico";
                hash = "sha256-2ZT4BrHkIltQvlq2gbLOz4RcwhahmkMth4zqPLgVuv0=";
              };
              name = "ddg";
              updateInterval = 7 * 24 * 60 * 60 * 1000;
              urls = [
                {
                  template = "https://duckduckgo.com/?q={searchTerms}&kbg=-1&kbe=0&kau=-1&kao=-1&kap=-1&kaq=-1&kax=-1&kak=-1";
                }
              ];
            };
            # get rid of all the random engines librewolf adds
            bing.metaData.hidden = true;
            ddg.metaData.hidden = true;
            "policy-DuckDuckGo Lite".metaData.hidden = true;
            google.metaData.hidden = true;
            policy-MetaGer.metaData.hidden = true;
            policy-Mojeek.metaData.hidden = true;
            "policy-SearXNG - searx.be".metaData.hidden = true;
            policy-StartPage.metaData.hidden = true;
          };
        };
        settings = {
          # keep-sorted start block=yes
          "browser.display.use_document_fonts" = 0;
          "browser.download.autohideButton" = true;
          "browser.download.dir" = config.xdg.userDirs.download;
          "browser.eme.ui.enabled" = false; # stop asking to enable DRM
          "browser.search.separatePrivateDefault" = false;
          "browser.startup.page" = 3;
          "font.default.x-western" = "sans-serif";
          "network.trr.mode" = 2;
          "network.trr.uri" = "https://dns.quad9.net/dns-query";
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

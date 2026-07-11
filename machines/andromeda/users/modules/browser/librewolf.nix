{ pkgs, ... }:

let
  lock-false = {
    Value = false;
    Status = "locked";
  };
  lock-true = {
    Value = true;
    Status = "locked";
  };
  extension-config-path = "/home/mustachio/.librewolf/extension-configs";
in
{
  programs.firefox = {
    enable = true;
    package = pkgs.librewolf;
    policies = {
      AppAutoUpdate = false;
      BackgroundAppUpdate = false;
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
        EmailTracking = true;
      };
      EncryptedMediaExtensions = {
        Enabled = true;
        Locked = true;
      };
      DisableBuiltinPDFViewer = true; # Considered a security liability
      OfferToSaveLogins = false;
      DisableFormHistory = true;
      HardwareAcceleration = true; # Exposes points for fingerprinting, but performance improves
      DisableSetDesktopBackground = true;
      DisableProfileRefresh = true;
      DisableProfileImport = true;
      DisablePocket = true;
      DisableFirefoxAccounts = true;
      DisableAccounts = false;
      PasswordManagerEnabled = false;
      DisableFirefoxScreenshots = true;
      DontCheckDefaultBrowser = true;
      NoDefaultBookmarks = true;
      DisplayBookmarksToolbar = "always";
      SearchBar = "unified";
      Preferences = {
        "cookiebanners.service.mode.privateBrowsing" = 2; # Block cookie banners in private browsing
        "cookiebanners.service.mode" = 2; # Block cookie banners
        "privacy.donottrackheader.enabled" = true;
        "privacy.fingerprintingProtection" = true;
        "privacy.resistFingerprinting" = true;
        "privacy.trackingprotection.emailtracking.enabled" = true;
        "privacy.trackingprotection.enabled" = true;
        "privacy.trackingprotection.fingerprinting.enabled" = true;
        "privacy.trackingprotection.socialtracking.enabled" = true;
        "browser.contentblocking.category" = {
          Value = "strict";
          Status = "locked";
        };
        "extensions.pocket.enabled" = lock-false;
        "extensions.screenshots.disabled" = lock-true;
        "browser.topsites.contile.enabled" = lock-false;
        "browser.formfill.enable" = lock-false;
        "browser.search.suggest.enabled" = lock-true;
        "browser.search.suggest.enabled.private" = lock-true;
        "browser.urlbar.suggest.searches" = lock-false;
        "browser.urlbar.showSearchSuggestionsFirst" = lock-true;
        "browser.newtabpage.activity-stream.feeds.section.topstories" = lock-false;
        "browser.newtabpage.activity-stream.feeds.snippets" = lock-false;
        "browser.newtabpage.activity-stream.section.highlights.includePocket" = lock-false;
        "browser.newtabpage.activity-stream.section.highlights.includeBookmarks" = lock-false;
        "browser.newtabpage.activity-stream.section.highlights.includeDownloads" = lock-false;
        "browser.newtabpage.activity-stream.section.highlights.includeVisited" = lock-false;
        "browser.newtabpage.activity-stream.showSponsored" = lock-false;
        "browser.newtabpage.activity-stream.system.showSponsored" = lock-false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = lock-false;
        "browser.policies.runOncePerModification.setDefaultSearchEngine" = "Kagi";
        "sidebar.verticalTabs" = lock-true;
      };

      ExtensionUpdate = false;

      # Use `nix run github:tupakkatapa/mozid -- [url-to-addon]` to get extension ID.
      ExtensionSettings = {
        "*" = {
          installation_mode = "blocked";
          blocked_install_message = "Add to nix config instead.";
        };
        "uBlock0@raymondhill.net" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "force_installed";
        };
        # Bitwarden
        "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
          installation_mode = "force_installed";
        };
        "search@kagi.com" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/kagi-search-for-firefox/latest.xpi";
          installation_mode = "force_installed";
        };
        "addon@darkreader.org" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
          installation_mode = "force_installed";
        };
        "deArrow@ajay.app" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/dearrow/latest.xpi";
          installation_mode = "force_installed";
        };
        "sponsorBlocker@ajay.app" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/sponsorblock/latest.xpi";
          installation_mode = "force_installed";
        };
        "enhancerforyoutube@maximerf.addons.mozilla.org" = {
          install_url = "https://www.mrfdev.com/downloads/enhancer_for_youtube-2.0.130.1.xpi";
          installation_mode = "force_installed";
        };
        "FirefoxColor@mozilla.com" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/file/3643624/firefox_color-2.1.7.xpi";
          installation_mode = "force_installed";
        };
        "myallychou@gmail.com" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/file/4733035/youtube_recommended_videos-1.6.9.xpi";
          installation_mode = "force_installed";
        };
      };

      PDFjs = {
        Enabled = false;
        EnablePermissions = false;
      };
      Handlers = {
        mimeTypes."application/pdf".action = "saveToDisk";
      };
      extensions = {
        pdf = {
          action = "useHelperApp";
          ask = true;
          handlers = [
            {
              name = "GNOME Document Viewer";
              path = "${pkgs.evince}/bin/evince";
            }
          ];
        };
      };

      PromptForDownloadLocation = true;
      StartDownloadsInTempDirectory = true;

      UserMessaging = {
        ExtensionRecommendations = false; # Don’t recommend extensions while the user is visiting web pages
        FeatureRecommendations = false; # Don’t recommend browser features
        Locked = true; # Prevent the user from changing user messaging preferences
        MoreFromMozilla = false; # Don’t show the “More from Mozilla” section in Preferences
        SkipOnboarding = true; # Don’t show onboarding messages on the new tab page
        UrlbarInterventions = false; # Don’t offer suggestions in the URL bar
        WhatsNew = false; # Remove the “What’s New” icon and menuitem
      };
      UseSystemPrintDialog = true;

      SearchEngines = {
        PreventInstalls = true;
        Add = [
          {
            Name = "Kagi";
            URLTemplate = "https://kagi.com/search?q={searchTerms}";
            Method = "GET";
            IconURL = "https://kagi.com/favicon.ico";
            SuggestURLTemplate = "https://kagi.com/api/autosuggest?q={searchTerms}";
          }
        ];
        Remove = [
          "Amazon.com"
          "Bing"
          "Google"
          "DuckDuckGo"
          "MetaGer"
          "Mojeek"
          "Searx Belgium"
          "Startpage"
        ];
        Default = "Kagi";
      };
    };

    profiles = {
      default = {
        id = 0;
        name = "default";
        isDefault = true;
        settings = {
          "browser.startup.homepage" = "https://kagi.com/";
          "browser.search.defaultenginename" = "Kagi";
          "browser.search.order.1" = "Kagi";
        };
      };
    };
  };

  age.secrets = {
    "ublock.config.txt" = {
      file = ./secrets/ublock.config.age;
      path = "${extension-config-path}/ublock.config.txt";
    };
    "enhancer-for-youtube.config.txt" = {
      file = ./secrets/enhancer-for-youtube.config.age;
      path = "${extension-config-path}/enhancer-for-youtube.config.txt";
    };
    "dearrow.config.json" = {
      file = ./secrets/dearrow.config.age;
      path = "${extension-config-path}/dearrow.config.json";
    };
    "bookmarks.json" = {
      file = ./secrets/bookmarks.age;
      path = "${extension-config-path}/bookmarks.json";
    };
    "sponsorblock.config.json" = {
      file = ./secrets/sponsorblock.config.age;
      path = "${extension-config-path}/sponsorblock.config.json";
    };
  };

  xdg.mimeApps.defaultApplications = {
    "text/html" = "librewolf.desktop";
    "x-scheme-handler/http" = "librewolf.desktop";
    "x-scheme-handler/https" = "librewolf.desktop";
    "x-scheme-handler/about" = "librewolf.desktop";
    "x-scheme-handler/unknown" = "librewolf.desktop";
  };
}

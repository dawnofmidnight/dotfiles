{ pkgs-unstable, ... }:
let
  eclipse-plugins = {
    checkstyle = pkgs-unstable.eclipses.plugins.buildEclipseUpdateSite rec {
      name = "checkstyle";
      version = "10.18.1.202409031410";
      src = pkgs-unstable.fetchFromGitHub {
        owner = "checkstyle";
        repo = "eclipse-cs-update-site";
        rev = "22a4546140dca1526c095f212450cd41308ef50a";
        hash = "sha256-0FNJP/TOAXMvASRfYokISCq4gbMUz0Ah/GFmjG42vuc=";
        sparseCheckout = [ "releases/${version}" ];
      };
      sourceRoot = "${src.name}/releases/${version}";
    };

    pmd = pkgs-unstable.eclipses.plugins.buildEclipseUpdateSite {
      name = "pmd";
      version = "7.6.0";
      src = pkgs-unstable.fetchzip {
        stripRoot = false;
        url = "https://github.com/pmd/pmd-eclipse-plugin/releases/download/7.6.0.v20240927-1030-r/net.sourceforge.pmd.eclipse.p2updatesite-7.6.0.v20240927-1030-r.zip";
        hash = "sha256-WxxqEIOinNaXK/fxyBNiSVHfNt2vUH2/KL3ust1lc0Q=";
      };
    };

    spotbugs = pkgs-unstable.eclipses.plugins.buildEclipseUpdateSite {
      name = "spotbugs";
      version = "4.8.6";
      src = pkgs-unstable.fetchzip {
        stripRoot = false;
        url = "https://github.com/spotbugs/spotbugs/releases/download/4.8.6/eclipsePlugin.zip";
        hash = "sha256-q52PDVpdXzDPqnHbj3gOXtYLbMv08AvK3PnBp8SxWN8=";
      };
    };
  };
in {
  home.packages = with pkgs-unstable; [ jdk21 jetbrains.idea-ultimate ];

  programs.eclipse = {
    enable = true;
    package = pkgs-unstable.eclipses.eclipse-java;
    plugins = with eclipse-plugins; [
      checkstyle
      pmd
      spotbugs
    ];
  };

  # makes java swing actually look half-decent for some reason
  home.sessionVariables = {
    _JAVA_AWT_WM_NONREPARENTING = 1;
    _JAVA_OPTIONS = "-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel";
  };
}

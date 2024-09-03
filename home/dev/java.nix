{ pkgs-unstable, ... }:
let
  eclipse-plugins = {
    checkstyle = pkgs-unstable.eclipses.plugins.buildEclipseUpdateSite rec {
      name = "checkstyle";
      version = "10.17.0.202408021402";
      src = pkgs-unstable.fetchFromGitHub {
        owner = "checkstyle";
        repo = "eclipse-cs-update-site";
        rev = "5d23b35192d118bd32f79c8e95771a0aa9020a3d";
        hash = "sha256-rhNlDm1iwAZ9fDzI+gnFikyB+iezuOqRgMIZc9IpWhY=";
        sparseCheckout = [ "releases/${version}" ];
      };
      sourceRoot = "${src.name}/releases/${version}";
    };

    pmd = pkgs-unstable.eclipses.plugins.buildEclipseUpdateSite {
      name = "pmd";
      version = "7.4.0";
      src = pkgs-unstable.fetchzip {
        stripRoot = false;
        url = "https://github.com/pmd/pmd-eclipse-plugin/releases/download/7.4.0.v20240726-0845-r/net.sourceforge.pmd.eclipse.p2updatesite-7.4.0.v20240726-0845-r.zip";
        hash = "sha256-IXizik45wbI9aUI/aS1eOs1H6quI/ubiKndc+b+4deg=";
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
  home.packages = with pkgs-unstable; [ jdk21 ];

  programs.eclipse = {
    enable = true;
    package = pkgs-unstable.eclipses.eclipse-java;
    plugins = with eclipse-plugins; [
      checkstyle
      pmd
      spotbugs
    ];
  };
}
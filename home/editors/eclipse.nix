{ pkgs-unstable, ... }:
{
  programs.eclipse = {
    package = pkgs-unstable.eclipses.eclipse-java;
    plugins = [
      (pkgs-unstable.eclipses.plugins.buildEclipseUpdateSite rec {
        name = "checkstyle";
        version = "10.20.1.202411071856";
        src = pkgs-unstable.fetchFromGitHub {
          owner = "checkstyle";
          repo = "eclipse-cs-update-site";
          rev = "a760b14c03e16c23dc9461222e31e4b2156ff88d";
          hash = "sha256-lCgtRmH1RKmy3EZOuD2XWqldRxbNo3H3I1KnNi9pBVg=";
          sparseCheckout = [ "releases/${version}" ];
        };
        sourceRoot = "${src.name}/releases/${version}";
      })

      (pkgs-unstable.eclipses.plugins.buildEclipseUpdateSite {
        name = "pmd";
        version = "7.7.0";
        src = pkgs-unstable.fetchzip {
          stripRoot = false;
          url = "https://github.com/pmd/pmd-eclipse-plugin/releases/download/7.7.0.v20241025-0829-r/net.sourceforge.pmd.eclipse.p2updatesite-7.7.0.v20241025-0829-r.zip";
          hash = "sha256-Dmeo6N5yfoSincg1f5nz4HZaDb3zvnAl05qzwhHG2d0=";
        };
      })

      (pkgs-unstable.eclipses.plugins.buildEclipseUpdateSite {
        name = "spotbugs";
        version = "4.8.6";
        src = pkgs-unstable.fetchzip {
          stripRoot = false;
          url = "https://github.com/spotbugs/spotbugs/releases/download/4.8.6/eclipsePlugin.zip";
          hash = "sha256-q52PDVpdXzDPqnHbj3gOXtYLbMv08AvK3PnBp8SxWN8=";
        };
      })
    ];
  };
}

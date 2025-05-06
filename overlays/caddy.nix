final: prev:
let
  plugins = [ "github.com/tailscale/caddy-tailscale" ];

  xcaddy = final.stdenvNoCC.mkDerivation rec {
    pname = "caddy-src";
    version = "2.9.1";
    nativeBuildInputs = [
      prev.go
      prev.xcaddy
    ];

    dontUnpack = true;
    buildPhase =
      let
        withArgs = final.lib.concatMapStrings (plugin: "--with ${plugin} ") plugins;
      in
      ''
        export GOCACHE=$TMPDIR/go-cache
        export GOPATH="$TMPDIR/go"
        XCADDY_SKIP_BUILD=1 TMPDIR="$PWD" xcaddy build v${version} ${withArgs}
        (cd buildenv* && go mod vendor)
      '';
    installPhase = ''
      mv buildenv* $out
    '';

    outputHashMode = "recursive";
    outputHash = "sha256-RPSH8TEQsn8/+XlAGWgG6QEQ6AlRC9H9u7pYH6dtteY=";
  };
in
prev.caddy.overrideAttrs (_prev: {
  src = xcaddy;
  doCheck = false; # takes longer than we'd like
  vendorHash = null;
  subPackages = [ "." ];
})

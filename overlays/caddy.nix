{ prev, final }: let
  plugins = [ "github.com/caddy-dns/cloudflare" ];
  goImports =
    prev.lib.flip prev.lib.concatMapStrings plugins (pkg: "   _ \"${pkg}\"\n");
  goGets = prev.lib.flip prev.lib.concatMapStrings plugins
    (pkg: "go get ${pkg}\n      ");
  main = ''
    package main
    import (
    	caddycmd "github.com/caddyserver/caddy/v2/cmd"
    	_ "github.com/caddyserver/caddy/v2/modules/standard"
    ${goImports}
    )
    func main() {
    	caddycmd.Main()
    }
  '';
in
prev.buildGoModule {
  pname = "caddy";
  version = prev.caddy.version;
  runVend = true;

  subPackages = [ "cmd/caddy" ];
  src = prev.caddy.src;
  vendorHash = "sha256-0Lw291cGHj4qXkfgp9wqNC6ZOHNRbKrkWfv3lCzwMv8=";

  overrideModAttrs = (_: {
    preBuild = ''
      echo '${main}' > cmd/caddy/main.go
      ${goGets}
    '';
    postInstall = "cp go.sum go.mod $out/ && ls $out/";
  });

  postPatch = ''
    echo '${main}' > cmd/caddy/main.go
    cat cmd/caddy/main.go
  '';

  postConfigure = ''
    cp vendor/go.sum ./
    cp vendor/go.mod ./
  '';
}

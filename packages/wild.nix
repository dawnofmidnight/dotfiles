{
  fetchFromGitHub,
  lib,
  nix-update-script,
  rustPlatform,
}:
rustPlatform.buildRustPackage rec {
  pname = "wild";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "davidlattimore";
    repo = "wild";
    rev = version;
    hash = "sha256-tVGvSd4aege3xz/CrEl98AwuEJlsM3nVVG0urTSajFQ=";
  };
  cargoHash = "sha256-dXIYJfjz6okiLJuX4ZHu0Ft2/9XDjCrvvl/eqeuvBkU=";

  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/davidlattimore/wild/blob/${version}/CHANGELOG.md";
    description = "Very fast linker for Linux";
    homepage = "https://github.com/davidlattimore/wild";
    license = [
      lib.licenses.asl20 # or
      lib.licenses.mit
    ];
    maintainers = [ lib.maintainers.dawnofmidnight ];
    mainProgram = "wild";
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
  };
}

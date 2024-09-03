{
  projectRootFile = "flake.nix";
  programs = {
    deadnix.enable = true;
    keep-sorted.enable = true;
    nixfmt = {
      enable = true;
      strict = true;
    };
  };
  settings.excludes = [
    "*.age"
    "*.jpg"
    "*.nu"
    "*.png"
    ".jj/*"
    "flake.lock"
    "hive/moonrise/borg-key-backup"
    "justfile"
  ];
}

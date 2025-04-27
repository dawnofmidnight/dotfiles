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
}

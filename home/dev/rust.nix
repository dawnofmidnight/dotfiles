{ lib, pkgs, pkgs-unstable, ... }: {
  home.packages = with pkgs-unstable; [ bacon ];

  home.file.".cargo/config.toml".text = ''
    [build]
    target-dir = ".cache/cargo-target"

    [target.x86_64-unknown-linux-gnu]
    linker = "${lib.getExe pkgs.llvmPackages_16.clang}"
    rustflags = ["-Clink-arg=-fuse-ld=${lib.getExe pkgs.mold}", "-Ctarget-cpu=native"]

    [unstable]
    gc = true
  '';
}

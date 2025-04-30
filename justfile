all: moonrise sunset

moonrise:
    # get into sudo mode before `nom` starts parsing output
    sudo ls > /dev/null
    sudo nixos-rebuild switch -v --log-format internal-json --flake .#moonrise |& nom --json

sunset:
    ssh sunset -- exit
    nom build --no-link .#nixosConfigurations.sunset.config.system.build.toplevel
    nixos-rebuild --target-host root@sunset switch --flake .#sunset

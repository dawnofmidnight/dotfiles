all: moonrise sunset

moonrise:
    # get into sudo mode before `nom` starts parsing output
    sudo ls > /dev/null
    sudo nixos-rebuild switch -v --log-format internal-json --flake .#moonrise |& nom --json

sunset:
    ssh sunset -- exit
    nixos-rebuild switch -v --log-format internal-json --flake .#sunset --target-host root@sunset |& nom --json

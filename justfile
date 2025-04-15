all: moonrise sunset

moonrise:
    sudo ls > /dev/null # get into sudo mode before `nom` starts parsing output
    sudo nixos-rebuild switch -v --log-format internal-json --flake .#moonrise |& nom --json

sunset:
    ssh-add -l | grep -q 'dawn@moonrise' || ssh-add
    nixos-rebuild --target-host root@152.7.58.97 switch -v --log-format internal-json --flake .#sunset |& nom --json

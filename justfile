sunset-ip := "152.7.58.97"

all: moonrise sunset

moonrise:
    # get into sudo mode before `nom` starts parsing output
    sudo ls > /dev/null
    sudo nixos-rebuild switch -v --log-format internal-json --flake .#moonrise |& nom --json

sunset:
    ssh-add -l | grep -q 'dawn@moonrise' || ssh-add
    nixos-rebuild --target-host root@{{sunset-ip}} switch -v --log-format internal-json --flake .#sunset |& nom --json

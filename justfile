all: local remote

local:
    colmena apply-local --sudo

remote:
    colmena apply

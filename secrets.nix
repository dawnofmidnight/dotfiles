let
  ssh-keys = (import ./util.nix).ssh-keys;
in
{
  "hive/common/tailscale-auth-key.age".publicKeys = ssh-keys.hosts;
  "hive/moonrise/ncsu-mount-config.age".publicKeys = [ ssh-keys.moonrise ];
  "hive/sunset/caddy-environment.age".publicKeys = [ ssh-keys.sunset ];
  "hive/sunset/cache-private-key.age".publicKeys = [ ssh-keys.sunset ];
}

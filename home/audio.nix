{ config, lib, ... }:
let
  cfg = config.dawn.audio;
in
{
  options.dawn.audio = lib.mkEnableOption "audio handling";

  config = lib.mkIf cfg {
    services.mpris-proxy.enable = true;
    services.playerctld.enable = true;
  };
}

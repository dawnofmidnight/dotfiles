{ config, lib, pkgs, ... }: {
  home.packages = with pkgs; [ mpc-cli yt-dlp ];

  programs.beets = {
    enable = true;
    mpdIntegration.enableUpdate = true;
    settings = {
      directory = config.xdg.userDirs.music;
      library = "${config.xdg.userDirs.music}/.beets.db";
      import.move = true;
    };
  };
  
  services.mpd = {
    enable = true;
    musicDirectory = config.xdg.userDirs.music;
    extraConfig = ''
      auto_update "yes"
      filesystem_charset "UTF-8"
      audio_output {
        type "pipewire"
        name "PipeWire Output"
      }
      zeroconf_enabled "no"
    '';
  };

  systemd.user.services.mpdscribble = {
    Unit = {
      Description = "mpdscribble server";
      After = [ "networking.target" ];
    };
    Install.WantedBy = [ "default.target" ];
    Service = {
      Type = "simple";
      ExecStart = "${lib.getExe pkgs.mpdscribble} --no-daemon --conf ${config.xdg.configHome}/mpdscribble/mpdscribble.conf";
      Restart = "on-failure";
    };
  };

  services.mpd-mpris.enable = true;
  programs.ncmpcpp.enable = true;
    
  services.mpris-proxy.enable = true;
  services.playerctld.enable = true;
}

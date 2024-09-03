{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.yarr;
in
{
  options.services.yarr = {
    enable = lib.mkEnableOption "yarr";

    package = lib.mkPackageOption pkgs "yarr" { };

    user = lib.mkOption {
      type = lib.types.str;
      default = "yarr";
      description = "User account under which yarr runs";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "yarr";
      description = "Group under which yarr runs";
    };

    addr = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1:7070";
      description = "address to run server on";
    };

    auth = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = lib.mdDoc "string with username and password in the format `username:password`";
    };

    authFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = lib.mkDoc "path to a file containing `username:password`. Takes precedence over `auth`";
    };

    base = lib.mkOption {
      type = lib.types.str;
      default = "";
      example = "/feeds";
      description = "base path of the service url";
    };

    certFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "path to cert file for https";
    };

    db = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/yarr/storage.db";
      description = "storage file path";
    };

    keyFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "path to key file for https";
    };

    logFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "path to log file to use instead of stdout";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.yarr = {
      description = "yarr";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = lib.getExe' cfg.package "yarr";
        DynamicUser = true;
        StateDirectory = "yarr";
        RuntimeDirectory = "yarr";
        LogsDirectory = "yarr";
        Restart = "on-failure";
        WorkingDirectory = "/var/lib/yarr";
        User = cfg.user;
        Group = cfg.group;
      };

      environment = {
        HOME = config.users.users.yarr.home;
        YARR_ADDR = cfg.addr;
        YARR_AUTH = cfg.auth;
        YARR_AUTHFILE = cfg.authFile;
        YARR_BASE = cfg.base;
        YARR_CERTFILE = cfg.certFile;
        YARR_DB = cfg.db;
        YARR_KEYFILE = cfg.keyFile;
        YARR_LOGFILE = cfg.logFile;
      };
    };

    users = {
      users = lib.mkIf (cfg.user == "yarr") {
        yarr = {
          inherit (cfg) group;
          home = "/var/lib/yarr";
          isSystemUser = true;
        };
      };

      groups = lib.mkIf (cfg.group == "yarr") { yarr = { }; };
    };
  };
}

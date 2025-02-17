{ config, lib, pkgs, utils, ... }:
let
  xcfg = config.services.xserver;
  cfg = xcfg.desktopManager.lxqt;

in

{
  meta = {
    maintainers = lib.teams.lxqt.members;
  };

  options = {

    services.xserver.desktopManager.lxqt.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable the LXQt desktop manager";
    };

    environment.lxqt.excludePackages = lib.mkOption {
      default = [];
      example = lib.literalExpression "[ pkgs.lxqt.qterminal ]";
      type = lib.types.listOf lib.types.package;
      description = "Which LXQt packages to exclude from the default environment";
    };

  };

  config = lib.mkIf cfg.enable {

    services.xserver.desktopManager.session = lib.singleton {
      name = "lxqt";
      bgSupport = true;
      start = ''
        # Upstream installs default configuration files in
        # $prefix/share/lxqt instead of $prefix/etc/xdg, (arguably)
        # giving distributors freedom to ship custom default
        # configuration files more easily. In order to let the session
        # manager find them the share subdirectory is added to the
        # XDG_CONFIG_DIRS environment variable.
        #
        # For an explanation see
        # https://github.com/lxqt/lxqt/issues/1521#issuecomment-405097453
        #
        export XDG_CONFIG_DIRS=$XDG_CONFIG_DIRS''${XDG_CONFIG_DIRS:+:}${config.system.path}/share

        exec ${pkgs.lxqt.lxqt-session}/bin/startlxqt
      '';
    };

    environment.systemPackages =
      pkgs.lxqt.preRequisitePackages ++
      pkgs.lxqt.corePackages ++
      (utils.removePackagesByName
        pkgs.lxqt.optionalPackages
        config.environment.lxqt.excludePackages);

    # Link some extra directories in /run/current-system/software/share
    environment.pathsToLink = [ "/share" ];

    programs.gnupg.agent.pinentryPackage = lib.mkDefault pkgs.pinentry-qt;

    # virtual file systems support for PCManFM-QT
    services.gvfs.enable = true;

    services.upower.enable = config.powerManagement.enable;

    services.libinput.enable = lib.mkDefault true;

    xdg.portal.lxqt.enable = lib.mkDefault true;

    # https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1050804
    xdg.portal.config.lxqt.default = lib.mkDefault [ "lxqt" "gtk" ];
  };

}

{ config, modulesPath, pkgs, lib, ... }:

with lib;

let
  cfg = config.nix-unify.modules;
in
{
  options.nix-unify.modules = {
    mergePath = {
      enable = mkEnableOption "path merging. /run/current-system/sw/bin will be appended to system path" // { default = true; };
    };
    useNixDaemon = {
      enable = mkEnableOption "usage of nix-unify provided daemon instead of nix install script daemon." // { default = true; };
    };
    etcMerge = {
      enable = mkEnableOption "etc merge module" // { default = true; };

      files = mkOption {
        description = "Add the following files to host /etc, symlinked from nix";
        default = [];
        type = types.listOf types.str;
      };
    };
    shareNftables = {
      enable = mkEnableOption "nftables rules";
    };
    shareSystemd = {
      enable = mkEnableOption "systemd units" // { default = true; };
      units = mkOption {
        description = "Units to share";
        default = [];
        type = types.listOf types.str;
      };
    };
  };

  config = mkMerge [
    (mkIf (cfg.shareNftables.enable) {
      nix-unify.modules.shareSystemd.units = [ "nftables.service" ];
    })
  ];
}
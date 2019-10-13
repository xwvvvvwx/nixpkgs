{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.networking;
in
{
  options = {
    networking.namespaces = mkOption {
      default = [];
      type = types.listOf types.str;
      description = ''
        A list of named network namespaces to create.
      '';
    };
  };
  config = mkIf (builtins.length cfg.namespaces != 0) {
    systemd.services.network-namespaces = {
      description = "Named network namespaces";
      before = [ "network.target" ];
      wantedBy = [ "network.target" ];
      after = [ "network-pre.target" ];
      path = [ pkgs.iproute ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = pkgs.writeScript "netns-up" ''
          #! ${pkgs.bash}/bin/bash
          for netns in ${toString cfg.namespaces}
          do
            ip netns add $netns
          done
        '';
        ExecStop = pkgs.writeScript "netns-down" ''
          #! ${pkgs.bash}/bin/bash
          for netns in ${toString cfg.namespaces}
          do
            ip netns del $netns
          done
        '';
      };
    };
  };
}

{ config, pkgs, ... }: {

  systemd.timers."wg-ha" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "5m";
      OnUnitActiveSec = "5m";
      Unit = "wg-ha.service";
    };
  };

  systemd.services."wg-ha" = {
    serviceConfig = {
      Type = "oneshot";
      WorkingDirectory = "/home/star/wg-ha";
      ExecStart =
        "${pkgs.bash}/bin/bash -c '${pkgs.nix}/bin/nix-shell --run \"python3 main.py\"'";
      Environment = "NIX_PATH=/nix/var/nix/profiles/per-user/root/channels/nixpkgs";
    };
  };
}

{ config, pkgs, ... }:

{
  services.wgha = {
    enable = true;
    tokenFile = "/etc/nixos/secrets/ha_token.key";
    baseurl = "http://192.168.0.97:8123/api";
    schedule = "*:0/5";
  };
}

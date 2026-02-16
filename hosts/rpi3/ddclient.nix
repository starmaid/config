{ config, pkgs, ... }: {
  services.ddclient = {
    enable = true;
    interval = "5min";
    use = "web";
    protocol = "porkbun";
    username = "pk1_a91688fe2d0abd104b6d74864ca888c9dc1f9f6a7217fbb89d62f8a1d0e09a14";
    passwordFile = "/etc/nixos/secrets/porkbun.key";
    domains = [ "starmaid.xyz" "chat.starmaid.xyz" "birdflight.starmaid.xyz" "cloud.starmaid.xyz" "office.starmaid.xyz" "turn.starmaid.xyz"];
    zone = "starmaid.xyz";
    ssl = true;
  };
}

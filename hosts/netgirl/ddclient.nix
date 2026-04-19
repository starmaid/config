{ config, pkgs, ... }: {
  services.ddclient = {
    enable = true;
    interval = "5min";
    use = "web";
    usev4 = "webv4";
    verbose = true;
    extraConfig = ''
protocol=porkbun
apikey=pk1_a91688fe2d0abd104b6d74864ca888c9dc1f9f6a7217fbb89d62f8a1d0e09a14
secretapikey=11111
starmaid.xyz,chat.starmaid.xyz,birdflight.starmaid.xyz,cloud.starmaid.xyz,office.starmaid.xyz,turn.starmaid.xyz
'';
  };
}

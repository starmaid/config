{ config, pkgs, ... }: {

  services.pihole-ftl = {
    enable = true;
    openFirewallDNS = true; # To open port 53 for DNS traffic
    openFirewallWebserver = true;

    # Settings documented at <https://docs.pi-hole.net/ftldns/configfile/>
    settings = {
      dns.upstreams = [ "8.8.8.8" "8.8.4.4" "1.1.1.1" "1.0.0.1" ];
      #misc.readOnly = false;
      webserver = {
        api = {
          # To manage the web login:
          # 1) Temporarily set misc.readOnly to false in
          #    configuration.nix and switch to it.
          # 2) Manually set a password:
          #    Pi-hole web console > Settings > All settings >
          #    Webserver and API > webserver.api.password > Value: ******
          # 3) Read the generated hash:
          #    sudo pihole-FTL --config webserver.api.pwhash
          pwhash =
            "$BALLOON-SHA256$v=1$s=1024,t=32$TOe67RC69bbGMFy+hLZ7aQ==$3gKi8DxFXh8W1QB6EjZh6mJ+5GDKiE7PevusK8AtRZQ=";
        };
      };
    };

    # Lists can be added via URL
    lists = [
      {
        url =
          "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/adblock/pro.txt";
        type = "block";
        enabled = true;
        description = "Sample blocklist by hagezi";
      }
      {
        url =
          "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts";
        type = "block";
        enabled = true;
        description = "Stevens block list";
      }
    ];
  };

  services.pihole-web = {
    enable = true;
    ports = [ 80 ];
  };
}

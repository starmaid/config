{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    github2forgejo = {
      url = "github:RGBCube/GitHub2Forgejo";

      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, github2forgejo, ... }:
    let
      inherit (nixpkgs) lib;
    in
    {
      nixosConfigurations.myserver = lib.nixosSystem {
        modules = [
          github2forgejo.nixosModules.default
          {
            nixpkgs.overlays = [ github2forgejo.overlays.default ];

            services.github2forgejo = {
              enable = true;

              # Something along the lines of:
              #
              # GITHUB_USER="RGBCube"
              # GITHUB_TOKEN="ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
              # FORGEJO_URL="https://git.rgbcu.be/"
              # FORGEJO_USER="RGBCube"
              # FORGEJO_TOKEN="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
              # STRATEGY="mirrored"
              # FORCE_SYNC="true"
              #
              # Do `GITHUB_TOKEN=""` if you want to only mirror public repositories of a person.
              # You HAVE TO set each one of these. Leaving one unset will make the systemd unit fail!
              environmentFile = "/secrets/github2forgejo.env";

              # The default runs every day at midnight. But you can override it like so:
              #
              # timerConfig = {
              #   OnCalendar         = "00:05";
              #   RandomizedDelaySec = "5h";
              #   Persistent         = true;
              # };
              #
              # Or you can disable the timer by setting `timerConfig` to null:
              #
              # timerConfig = null;
            };
          }
        ];
      };
    };
}

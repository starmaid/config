{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/567a49d1913ce81ac6e9582e3553dd90a955875f";
    t2fanrd.url = "github:GnomedDev/T2FanRD";
    github2forgejo.url = "github:RGBCube/GitHub2Forgejo";
  };
  outputs =
    {
      self,
      nixpkgs,
      t2fanrd,
      github2forgejo,
      ...
    }:

    let
      system = "x86_64-linux"; # Adjust to your architecture
      pkgs = nixpkgs.legacyPackages.${system};
      libfreenect =
        pkgs.callPackage "/home/star/Projects/2026-10-29_kinect-nix/attempt 2/libfreenect/default.nix"
          { };

    in
    {
      packages.${system}.libfreenect = libfreenect;

      nixosConfigurations.star-mbp20 = nixpkgs.lib.nixosSystem {
        modules = [
          ./configuration.nix
          t2fanrd.nixosModules.t2fanrd
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
              environmentFile = "/home/star/config/hosts/star-mbp20/files/gh2fj/github2forgejo.env";

              # The default runs every day at midnight. But you can override it like so:
              #
              timerConfig = {
                OnCalendar         = "weekly";
                RandomizedDelaySec = "1h";
                Persistent         = true;
              };
              #
              # Or you can disable the timer by setting `timerConfig` to null:
              #
              # timerConfig = null;
            };
          }
        ];
        specialArgs = {
          inherit libfreenect;
        };
      };
    };
}

{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/567a49d1913ce81ac6e9582e3553dd90a955875f";
    t2fanrd.url = "github:GnomedDev/T2FanRD";
  };
  outputs =
    {
      self,
      nixpkgs,
      t2fanrd,
      ...
    }:
    {
      nixosConfigurations.star-mbp20 = nixpkgs.lib.nixosSystem {
        modules = [
          ./configuration.nix
          t2fanrd.nixosModules.t2fanrd
        ];
      };
    };
}

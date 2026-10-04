{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/26.11";
    t2fanrd.url = "github:GnomedDev/T2FanRD";
  };
  outputs =
    {
      self,
      nixpkgs,
      wgha,
      ...
    }:
    {
      nixosConfigurations.netgirl2 = nixpkgs.lib.nixosSystem {
        modules = [
          ./configuration.nix
        ];
      };
    };
}

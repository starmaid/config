{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/25.11";
    wgha.url = "github:starmaid/wgha";
    wgha.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = { self, nixpkgs, wgha, ... }: {
    nixosConfigurations.netgirl = nixpkgs.lib.nixosSystem {
      modules = [
        ./configuration.nix
        wgha.nixosModules.aarch64-linux.wgha
      ];
    };
  };
}

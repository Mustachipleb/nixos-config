{
  description = "Root of configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with
      # the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs.
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-jetbrains-plugins.url = "github:nix-community/nix-jetbrains-plugins";
  };

  outputs =
    inputs@{
      nixpkgs,
      home-manager,
      nix-jetbrains-plugins,
      ...
    }:
    let
      system = "x86_64-linux";
    in
    {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-tree;
      nixosConfigurations.andromeda = nixpkgs.lib.nixosSystem {
        inherit system;

        modules = [
          ./configuration.nix

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.users.mustachio = import ./users/mustachio.nix;

            # Optionally, use home-manager.extraSpecialArgs to pass arguments to mustachio.nix
            home-manager.extraSpecialArgs = {
              inherit system nix-jetbrains-plugins;
            };
          }
        ];
      };
    };
}

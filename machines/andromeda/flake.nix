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
    ldmtool-src = {
      url = "github:mdbooth/libldm";
      flake = false;
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      nixpkgs,
      home-manager,
      nix-jetbrains-plugins,
      ldmtool-src,
      agenix,
      ...
    }:
    let
      system = "x86_64-linux";
    in
    {
      formatter.x86_64-linux = nixpkgs.legacyPackages.${system}.nixfmt-tree;
      nixosConfigurations.andromeda = nixpkgs.lib.nixosSystem {
        inherit system;

        modules = [
          ./configuration.nix
          agenix.nixosModules.default
          {
            environment.systemPackages = [ agenix.packages.${system}.default ];
          }
          (
            { pkgs, ... }:
            {
              nixpkgs.overlays = [
                (final: prev: {
                  ldmtool = prev.ldmtool.overrideAttrs (oldAttrs: {
                    src = ldmtool-src;
                    # Patches for 0.2.4 are merged into master, so this can be set empty
                    patches = [ ];
                  });
                })
              ];
            }
          )

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

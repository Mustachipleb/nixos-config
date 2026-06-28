{
  description = "Root of configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with
      # the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs.
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-jetbrains-plugins = {
      url = "github:nix-community/nix-jetbrains-plugins";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      nix-jetbrains-plugins,
      agenix,
      spicetify-nix,
      ...
    }:
    let
      system = "x86_64-linux";
      unstablePkgs = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      formatter.x86_64-linux = nixpkgs.legacyPackages.${system}.nixfmt-tree;
      packages.${system}.deploy-andromeda = nixpkgs.legacyPackages.${system}.writeShellApplication {
        name = "deploy-andromeda";
        runtimeInputs = with nixpkgs.legacyPackages.${system}; [
          git
          gnugrep
          gawk
        ];
        text = ''
          set -euo pipefail

          echo "Deploying Andromeda configuration..."

          cd /home/mustachio/nixos-config/

          if ! git diff --quiet || ! git diff --cached --quiet; then
            echo "Refusing deployment: git tree is dirty." >&2
            exit 1
          fi

          nh os switch

          gen="$(sudo nix-env -p /nix/var/nix/profiles/system --list-generations | tail -n1 | awk '{print $1}')"
          tag="deploy/andromeda/gen-''${gen}"

          if git rev-parse -q --verify "refs/tags/''${tag}" >/dev/null; then
            echo "Tag already exists: ''${tag}" >&2
            exit 1
          fi

          git tag -a "''${tag}" -m "andromeda generation ''${gen}"
          git push origin "''${tag}"
        '';
      };
      apps.${system}.deploy-andromeda = {
        type = "app";
        program = "${self.packages.${system}.deploy-andromeda}/bin/deploy-andromeda";
      };
      nixosConfigurations.andromeda = nixpkgs.lib.nixosSystem {
        inherit system;

        specialArgs = {
          nixpkgs-unstable = unstablePkgs;
        };

        modules = [
          ./configuration.nix
          agenix.nixosModules.default
          {
            environment.systemPackages = [ agenix.packages.${system}.default ];
          }
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.users.mustachio = import ./users/mustachio.nix;

            # Optionally, use home-manager.extraSpecialArgs to pass arguments to mustachio.nix
            home-manager.extraSpecialArgs = {
              inherit system nix-jetbrains-plugins spicetify-nix;
              nixpkgs-unstable = unstablePkgs;
            };
          }
        ];
      };
    };
}

{
  description = "Root of configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
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
    stylix = {
      url = "github:nix-community/stylix/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
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
      stylix,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      unstablePkgs = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
      revision =
        if self ? shortRev then
          self.shortRev
        else if self ? dirtyShortRev then
          self.dirtyShortRev
        else if self ? lastModified then
          toString self.lastModified
        else
          "unknown";

      baseSpecialArgs = {
        inherit
          agenix
          nix-jetbrains-plugins
          spicetify-nix
          system
          ;
        nixpkgs-unstable = unstablePkgs;
      };

      revisionModule = {
        system.configurationRevision = revision;
        system.nixos.label = revision;
      };

      mkHomeManagerModule =
        {
          users,
          sharedModules ? [ ],
          backupFileExtension ? null,
        }:
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.sharedModules = sharedModules;
          home-manager.users = users;
          home-manager.extraSpecialArgs = baseSpecialArgs;
          home-manager.backupFileExtension = nixpkgs.lib.mkIf (
            backupFileExtension != null
          ) backupFileExtension;
        };

      mkHost =
        {
          modules,
          specialArgs ? { },
        }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = baseSpecialArgs // specialArgs;
          modules = [ revisionModule ] ++ modules;
        };
    in
    {
      nixosModules = import ./modules/nixos;
      homeManagerModules = import ./modules/home-manager;

      formatter.${system} = pkgs.nixfmt-tree;

      packages.${system}.deploy-andromeda = pkgs.writeShellApplication {
        name = "deploy-andromeda";
        runtimeInputs = with pkgs; [
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

      nixosConfigurations = {
        andromeda = mkHost {
          modules = [
            stylix.nixosModules.stylix
            self.nixosModules.stylix
            agenix.nixosModules.default
            ./machines/andromeda/configuration.nix
            {
              environment.systemPackages = [ agenix.packages.${system}.default ];
            }
            home-manager.nixosModules.home-manager
            (mkHomeManagerModule {
              users.mustachio = import ./machines/andromeda/users/mustachio.nix;
              sharedModules = [
                agenix.homeManagerModules.default
                self.homeManagerModules.shell
                self.homeManagerModules.git
                self.homeManagerModules.jetbrains
                self.homeManagerModules.stylix
              ];
              backupFileExtension = "hm-backup";
            })
          ];
        };

        circinus = mkHost {
          modules = [
            ./machines/circinus/configuration.nix
            home-manager.nixosModules.home-manager
            (mkHomeManagerModule {
              users.mustachio = import ./machines/circinus/users/mustachio.nix;
              sharedModules = [
                self.homeManagerModules.shell
                self.homeManagerModules.git
              ];
              backupFileExtension = "hm-backup";
            })
          ];
        };

        triangulum = mkHost {
          modules = [
            agenix.nixosModules.default
            ./machines/triangulum/configuration.nix
            {
              environment.systemPackages = [ agenix.packages.${system}.default ];
            }
            home-manager.nixosModules.home-manager
            (mkHomeManagerModule { users = { }; })
          ];
        };

        condor = mkHost {
          modules = [
            ./machines/condor/configuration.nix
            agenix.nixosModules.default
            home-manager.nixosModules.home-manager
            (mkHomeManagerModule {
              users.mustachio = import ./machines/condor/users/mustachio.nix;
              sharedModules = [
                agenix.homeManagerModules.default
                self.homeManagerModules.shell
                self.homeManagerModules.git
              ];
              backupFileExtension = "hm-backup";
            })
          ];
        };
      };

      checks.${system} = {
        formatting =
          pkgs.runCommand "formatting-check"
            {
              nativeBuildInputs = [ self.formatter.${system} ];
            }
            ''
              export HOME="$TMPDIR"
              cp -r ${./.} source
              chmod -R u+w source
              cd source

              treefmt --ci --tree-root "$PWD" .

              touch "$out"
            '';
        andromeda-build = self.nixosConfigurations.andromeda.config.system.build.toplevel;
        circinus-build = self.nixosConfigurations.circinus.config.system.build.toplevel;
        triangulum-build = self.nixosConfigurations.triangulum.config.system.build.toplevel;
      };
    };
}

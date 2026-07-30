# NixOS Configuration

This repository contains a single root flake for all configured machines. It combines NixOS, Home Manager, and a small
set of shared modules so host-specific configuration stays local while reusable behavior lives in one place.

## Overview

- The root flake is [flake.nix](/home/mustachio/nixos-config/flake.nix).
- It currently defines three hosts: `andromeda`, `circinus`, and `triangulum`.
- Home Manager is wired in through the NixOS configurations rather than being managed as a separate flake.
- Shared Home Manager modules are exported through `self.homeManagerModules`.
- `common/` still exists, but it is transitional. New shared code should go in `modules/`.

## Repository Layout

- [flake.nix](/home/mustachio/nixos-config/flake.nix): Root flake, inputs, exported modules, host definitions, checks,
  and helper packages/apps.
- `machines/<host>/`: Host-specific NixOS configuration.
- `machines/<host>/users/`: Host-specific Home Manager user definitions and host-local user modules.
- `modules/home-manager/`: Reusable Home Manager modules exported by the flake.
- `modules/nixos/`: Reusable NixOS modules exported by the flake.
- `common/`: Older shared modules and fragments. Prefer `modules/` for new work.
- [TODOs.md](/home/mustachio/nixos-config/TODOs.md): Active follow-up work and refactor notes.

## Working with the Repo

Use explicit host targets unless you have deliberately aligned flake output names with machine hostnames everywhere.

Build a host:

```sh
nix build .#nixosConfigurations.andromeda.config.system.build.toplevel
```

Dry-run a switch or boot:

```sh
nh os switch --dry /home/mustachio/nixos-config#andromeda
nh os boot --dry /home/mustachio/nixos-config#andromeda
```

Apply a host:

```sh
sudo nixos-rebuild switch --flake /home/mustachio/nixos-config#andromeda
```

Format the repo:

```sh
nix fmt
```

Inspect what the flake exports:

```sh
nix flake show
```

## Effective Workflow

When changing a single machine:

- Keep machine-specific settings in `machines/<host>/`.
- Keep shared behavior in a module under `modules/`.
- Prefer setting values in the host config and implementing behavior in the shared module.

When adding a reusable Home Manager module:

1. Add the module under `modules/home-manager/<name>/default.nix` if it has related assets, or
   `modules/home-manager/<name>.nix` if it is truly single-file.
2. Export it from [modules/home-manager/default.nix](/home/mustachio/nixos-config/modules/home-manager/default.nix).
3. Consume it through `self.homeManagerModules.<name>` in [flake.nix](/home/mustachio/nixos-config/flake.nix).
4. Configure it from the relevant user config.

When adding a reusable NixOS module:

1. Put it under `modules/nixos/`.
2. Export it from the root flake under `nixosModules`.
3. Import it in the target host via `self.nixosModules.<name>`.

## Current Conventions

- Use the root flake as the single entry point.
- Prefer proper NixOS/Home Manager modules over attrset fragments.
- Prefer namespaced options such as `drlg.*` for custom module APIs.
- Avoid hard-coded host-specific paths in shared modules.
- Treat `common/` as legacy. It is still in use, but new shared code should move to `modules/`.

## Notes

- `andromeda` currently has the most developed configuration and is the main reference host.
- `circinus` and `triangulum` are in the middle of being rebuilt into the new structure.
- `triangulum/README.md` and parts of `common/` describe the ohlder layout and are no longer the source of truth.

# Copilot Instructions for NixOS Configuration

## Build, Test, and Lint Commands

### Formatting
Format the repository with:
```bash
nix fmt
```

The formatter is `nixfmt-tree`, configured in `flake.nix`. EditorConfig uses 2-space indentation.

### Build and Validation
Build a specific host's system configuration:
```bash
nix build .#nixosConfigurations.<HOST>.config.system.build.toplevel
```
Replace `<HOST>` with `andromeda`, `circinus`, `triangulum`, or `condor`.

Run all checks (formatting + builds for all hosts):
```bash
nix flake check
```

### Deploy Commands
For andromeda (the primary reference host):

Dry-run before switching:
```bash
nh os switch --dry /home/mustachio/nixos-config#andromeda
```

Actual deployment (requires git tree to be clean):
```bash
nix run .#deploy-andromeda
```

## High-Level Architecture

### Structure
- **Root flake** (`flake.nix`): Single entry point managing all hosts, inputs, module exports, checks, and helper packages.
- **Machines** (`machines/<host>/`): Host-specific NixOS configuration and users.
- **Shared modules** (`modules/`): Reusable NixOS and Home Manager modules exported by the flake.
- **Legacy code** (`common/`): Older shared modules (deprecated; new work goes in `modules/`).

### Hosts
- `andromeda`: Most developed, primary reference configuration
- `circinus`: Being rebuilt into new structure
- `triangulum`: Being rebuilt into new structure
- `condor`: NAS/network storage server

### Module System
The flake exports:
- `nixosModules`: For NixOS-specific reusable modules
- `homeManagerModules`: For Home Manager modules (user-level config)

Home Manager is integrated into NixOS configurations via the root flake's `mkHomeManagerModule` helper, not as a separate flake.

### Naming
The flake uses the `drlg.*` namespace for all custom module options to avoid collisions with standard NixOS/Home Manager options.

## Key Conventions

### When Adding Reusable Code

**Home Manager modules:**
1. Add under `modules/home-manager/<name>/default.nix` (if it has related assets) or `modules/home-manager/<name>.nix` (if single-file)
2. Export from `modules/home-manager/default.nix`
3. Configure from user config using `self.homeManagerModules.<name>`

**NixOS modules:**
1. Add under `modules/nixos/`
2. Export from root flake's `nixosModules`
3. Import in target host via `self.nixosModules.<name>`

### Design Principles
- Use the root flake as the **single entry point** — always explicit with `flake.nix#<host>`
- Prefer **proper NixOS/Home Manager modules** over attrset fragments
- Use **namespaced options** like `drlg.*` for all custom settings
- Avoid **hard-coded host-specific paths** in shared modules; use `config.home.homeDirectory` (HM) or `config.users.users.<name>.home` (NixOS)
- Treat `common/` as **legacy** — new shared code should go in `modules/`

### When Modifying a Single Machine
- Keep machine-specific settings in `machines/<host>/`
- Keep shared behavior in a module under `modules/`
- Prefer setting values in the host config and implementing behavior in the shared module

## Active Work
See [TODOs.md](../TODOs.md) for ongoing refactoring and feature work. Quality gates (CI checks for formatting, deadcode analysis, and host builds) are planned but not yet implemented.

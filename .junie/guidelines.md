### Project Structure

This is a NixOS configuration repository managed with Flakes. It supports multiple machines and shared configurations.

- `machines/`: Host-specific configurations. Each subdirectory (e.g., `andromeda`, `box1`, `surface`) contains the
  `configuration.nix` and `hardware-configuration.nix` for that specific machine.
- `common/`: Shared Nix modules used across multiple machines (e.g., networking, GPU drivers, common user settings).
- `flake.nix`: The entry point for the NixOS configuration. It defines the outputs for each machine.
- `home-manager`: User-specific environment configurations are often found in `machines/<machine>/users/` or shared in
  `common/home.nix`.

### Guidelines for Junie

- **Language**: Always communicate in the language of the issue description (defaulting to English).
- **Style**: Follow the existing Nix code style. Use `nixfmt` if available for formatting changes.
- **Scope**: When modifying machine-specific configurations, ensure changes don't unintentionally affect other machines
  unless they are in `common/`.
- **Modifying Configuration**:
  - If adding a system-wide package, consider if it belongs in `machines/<machine>/configuration.nix` or a shared module
    in `common/`.
  - If adding a user-specific package or setting, use the appropriate Home Manager file (e.g.,
    `machines/andromeda/users/mustachio.nix`).

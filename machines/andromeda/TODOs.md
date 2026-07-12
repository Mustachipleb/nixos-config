- [x] Move librewolf to home manager so that profiles can be customised.
- [ ] I saw your scratchpad about referencing sponsorblock.config. If you want to automate the import of those .age
  configs into Librewolf, you could use a home.activation script to symlink or copy the decrypted files into the actual
  profile directory if the browser doesn't pick them up from the custom path.
- [ ] Single flake for all machines.
- [ ] Replace /home/mustachio with config.home.homeDirectory (HM) and config.users.users.<name>.home (NixOS)
- [ ] Add “quality gates” so refactors stay fun Add a checks section (or just a CI workflow) that runs: nix fmt (you
  already have nixfmt-tree), deadnix, statix, plus “can every host build?” via nix build .#nixosConfigurations.<host>
  .config.system.build.toplevel.
- [ ] Better module structure.

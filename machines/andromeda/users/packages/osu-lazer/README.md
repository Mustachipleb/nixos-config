`nix-build -E 'with (import <nixpkgs> {}); (callPackage ./osu-lazer.nix {}).fetch-deps'`

Then run `./result`

# BER MEtaOCaml NIix Flakes Environment

## Setup

Nix only provides opam; opam itself manages the BER-MetaOCaml switch,
following the official install instructions at
https://okmij.org/ftp/ML/MetaOCaml.html. Everything else (`opam init`,
creating the switch, installing `dune` / `ocaml-lsp-server` /
`ocamlformat`, creating `.ocamlformat`) is automated in the flake's
`shellHook`, so entering the dev shell is all that's needed.

0. set `flake.nix` and `.envrc`

- flake.nix

```nix
{
  description = "BER-MetaOCaml development environment";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    inputs:
    inputs.flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = inputs.nixpkgs.legacyPackages.${system};
        berMetaocamlSwitch = "5.3.0+BER";
        opamDevPackages = [
          "dune"
          "ocaml-lsp-server"
          "ocamlformat"
        ];
      in
      {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            opam
          ];
          shellHook = ''
            if ! opam switch list --short 2>/dev/null | grep -qx "${berMetaocamlSwitch}"; then
              opam init --bare --no-setup -y
              opam switch create ${berMetaocamlSwitch}
            fi
            eval $(opam env --switch=${berMetaocamlSwitch} --set-switch)
            opam install --yes ${pkgs.lib.concatStringsSep " " opamDevPackages}
            [ -f .ocamlformat ] || touch .ocamlformat
          '';
        };
      }
    );
}
```

- .envrc

```sh
use flake
```

1. enter the dev shell

```sh
nix develop
```

(or `direnv allow`, if using direnv and nix-direnv). On the first run this builds
the BER-MetaOCaml compiler, every run after that is near-instant,
since opam skips anything already installed.
Check https://okmij.org/ftp/ML/MetaOCaml.html for the latest switch name
if a newer BER-MetaOCaml release is out, and bump `berMetaocamlSwitch`
in `flake.nix` accordingly.


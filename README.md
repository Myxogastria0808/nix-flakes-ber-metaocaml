## Setup

0. set `flake.nix` and `.envrc`

- flake.nix

```nix
{
  description = "ocaml-mytutorial";
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
      in
      {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            ocaml
            opam
          ];
          shellHook = ''
              eval $(opam env --switch=default)
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

1. initialize opam

```sh
opam init
```

- shell hook selection

You should select the 5th (5. No, I'll remember to run eval $(opam env) when I need opam).

2. create `.ocamlformat`

```sh
touch .ocamlformat
```

3. install `ocaml-lsp-server` and `ocamlformat`

```sh
opam install --yes ocaml-lsp-server
opam install --yes ocamlformat
```

## Hot to Run

```sh
ocaml hoge.ml
```

or

```sh
ocamlc hoge.ml
./a.out
```

## References

https://qiita.com/h-shima/items/80c12625922adeba764c

https://zenn.dev/deerman3189/articles/fc1976a0455e58

https://jsprimer.net/basic/statement-expression/

- setup ocaml environment

https://zenn.dev/atsushifx/articles/edu-ocaml-devtools-vscode-setup

- primitive types reference

https://www.math.nagoya-u.ac.jp/~garrigue/lecture/2012_AW/ocaml1.pdf

- helper functions

https://www.fos.kuis.kyoto-u.ac.jp/~igarashi/class/isle4-02w/mltext/ocaml005.html


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


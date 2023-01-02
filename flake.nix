{
  description = "Petri";

  nixConfig.extra-substituters = [
    "https://tweag-jupyter.cachix.org"
  ];
  nixConfig.extra-trusted-public-keys = [
    "tweag-jupyter.cachix.org-1:UtNH4Zs6hVUFpFBTLaA4ejYavPo5EFFqgd7G7FxGW9g="
  ];

  inputs = {
    flake-compat.url = "github:edolstra/flake-compat";
    flake-compat.flake = false;
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    jupyterWith.url = "github:tweag/jupyterWith";
  };

  outputs = {
    self,
    flake-compat,
    flake-utils,
    nixpkgs,
    jupyterWith,
  }:
    flake-utils.lib.eachSystem
    [
      flake-utils.lib.system.x86_64-linux
    ]
    (
      system: let
        pkgs = import nixpkgs { inherit system; };
        inherit (jupyterWith.lib.${system}) mkJupyterlabFromPath;
        jupyterlab = mkJupyterlabFromPath ./kernels {inherit system;};
      in rec {
        packages = {inherit jupyterlab;};
        packages.default = jupyterlab;
        apps.default.program = "${jupyterlab}/bin/jupyter-lab";
        apps.default.type = "app";
        devShell = pkgs.mkShell {
          name = "petri-shell";
          propagatedBuildInputs = with pkgs; [
            julia
          ];
          shellHook = ''
            command -v fish &> /dev/null && fish
          '';
        };
      }
    );
}

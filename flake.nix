{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/master";
    nix-filter.url = "github:numtide/nix-filter";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, nix-filter }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };

        nix-src = nix-filter.lib.filter {
          root = ./.;
          include = [
            (nix-filter.lib.matchExt "nix")
          ];
        };

        buildInputs = with pkgs; [
        ];

        nativeBuildInputs = with pkgs; [
        ];
      in
      {
        checks = {
          nixpkgs-fmt = pkgs.runCommand "check-nixpkgs-fmt"
            {
              nativeBuildInputs = with pkgs;
                [
                  nixpkgs-fmt
                ];
            }
            ''
              mkdir $out
              nixpkgs-fmt --check ${nix-src}
            '';
        };

        devShells = flake-utils.lib.flattenTree rec {
          default = pkgs.mkShell {
            buildInputs = with pkgs; [
              yarn
            ] ++ buildInputs ++ nativeBuildInputs;
          };
        };

      }
    );
}

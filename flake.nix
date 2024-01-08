{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/master";
    nix-filter.url = "github:numtide/nix-filter";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, nix-filter }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        version = "v1.11.0";
        dist = {
          aarch64-darwin = rec {
            url = "https://github.com/nhost/cli/releases/download/${version}/cli-${version}-darwin-arm64.tar.gz";
            sha256 = "sha256-rJLm4KNLLT0GJ6lntLD27RkVo68gIuUhUgbwl42gL+Q=";
          };
          x86_64-linux = rec {
            url = "https://github.com/nhost/cli/releases/download/${version}/cli-${version}-linux-amd64.tar.gz";
            sha256 = "14dwlvxmdqdxpzwjw37w32nq5jsfygfzi3n1gz7k8yxlmf6han7";
          };
        };
        overlays = [
          (final: prev: rec {
            nhost = final.stdenvNoCC.mkDerivation rec {
              pname = "nhost-cli";
              inherit version;

              src = final.fetchurl {
                inherit (dist.${final.stdenvNoCC.hostPlatform.system} or
                  (throw "Unsupported system: ${final.stdenvNoCC.hostPlatform.system}")) url sha256;
              };


              sourceRoot = ".";

              nativeBuildInputs = [
                final.makeWrapper
                final.installShellFiles
              ];

              installPhase = ''
                runHook preInstall

                mkdir -p $out/bin
                mv cli $out/bin/nhost

                installShellCompletion --cmd nhost \
                  --bash <($out/bin/nhost completion bash) \
                  --fish <($out/bin/nhost completion fish) \
                  --zsh <($out/bin/nhost completion zsh)

                runHook postInstall
              '';

              meta = with final.lib; {
                description = "Nhost CLI";
                homepage = "https://nhost.io";
                license = licenses.mit;
                maintainers = [ "@nhost" ];
              };


            };
          }
          )
        ];
        pkgs = import nixpkgs {
          inherit system overlays;
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
              nhost
            ] ++ buildInputs ++ nativeBuildInputs;
          };
        };

      }
    );
}

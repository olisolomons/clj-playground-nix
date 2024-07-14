{
  description = "A clj-nix flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    clj-nix.url = "github:jlesquembre/clj-nix";
  };

  outputs = { self, nixpkgs, flake-utils, clj-nix }:

    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = import nixpkgs { inherit system; };
      in {
        packages = {
          default = clj-nix.lib.mkCljApp {
            pkgs = pkgs;
            modules = [
              # Option list:
              # https://jlesquembre.github.io/clj-nix/options/
              {
                projectSrc = ./.;
                name = "me.osolomons/clj-playground";
                main-ns = "hello.core";

                nativeImage.enable = true;

                # customJdk.enable = true;
              }
            ];
          };
        };
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            clojure
            clojure-lsp
            (writeShellScriptBin "deps-lock" ''
              nix run github:jlesquembre/clj-nix#deps-lock
            '')
            (writeShellScriptBin "repl" ''
              clj -Sdeps '{:aliases {:nrepl {:extra-deps {nrepl/nrepl {:mvn/version "1.2.0"}}}}}' -M:nrepl -m nrepl.cmdline
            '')
          ];
        };
      });
}

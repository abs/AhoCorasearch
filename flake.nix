{
  description = "AhoCorasearch - Elixir Aho-Corasick string searching with Rust NIF";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        mkDevShell = { elixir, erlang, name }: pkgs.mkShell {
          buildInputs = [
            elixir
            erlang

            # Rust for NIF compilation
            pkgs.rustc
            pkgs.cargo

            # Build tools
            pkgs.gcc
            pkgs.gnumake
          ];

          shellHook = ''
            export MIX_HOME=$PWD/.nix-mix-${name}
            export HEX_HOME=$PWD/.nix-hex-${name}
            export PATH=$MIX_HOME/bin:$HEX_HOME/bin:$PATH
            export ERL_AFLAGS="-kernel shell_history enabled"
          '';
        };
      in
      {
        devShells = {
          default = mkDevShell {
            name = "elixir-1.19";
            elixir = pkgs.elixir_1_19;
            erlang = pkgs.erlang_27;
          };

          elixir_1_18 = mkDevShell {
            name = "elixir-1.18";
            elixir = pkgs.elixir_1_18;
            erlang = pkgs.erlang_27;
          };
        };
      }
    );
}

{
  description = "divdump - Phoenix SSE & API";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:  
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            erlang
            elixir
            elixir-ls
            nodejs
            sqlite
            inotify-tools
            direnv
          ];
          shellHook = ''
            export MIX_ENV=dev
            export SECRET_KEY_BASE=$(mix phx.gen.secret)
          '';
        };
      }
    );
}


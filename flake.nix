{
  description = "divsoup - serious website analyzer";

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
            chromium
            opentofu
          ];
          shellHook = ''
            export MIX_ENV=dev
            export SECRET_KEY_BASE=$(mix phx.gen.secret)
            
            # Load environment variables from .env file if it exists
            if [ -f .env ]; then
              echo "Loading AWS credentials from .env file..."
              set -a
              source .env
              set +a
              
              # Export Terraform variables from environment
              export TF_VAR_aws_region=$AWS_REGION
              export TF_VAR_bucket_name=$S3_BUCKET
              
              echo "AWS credentials loaded:"
              echo "  Region: $AWS_REGION"
              echo "  Bucket: $S3_BUCKET" 
              echo "  Access Key ID: ''${AWS_ACCESS_KEY_ID:0:5}... (truncated for security)"
              if [ -n "$AWS_SECRET_ACCESS_KEY" ]; then
                echo "  Secret Access Key: ✓"
              else
                echo "  Secret Access Key: ❌ MISSING!"
              fi
            else
              echo "⚠️ Warning: .env file not found in project root!"
              echo "AWS S3 integration will not work without credentials."
            fi
          '';
        };
      }
    );
}


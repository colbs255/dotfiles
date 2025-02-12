{
  description = "My nix config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs =
        nixpkgs.legacyPackages.${system}.extend (
          final: prev: {
            # Add firefox extensions to our packages
            firefox-extensions = inputs.firefox-addons.packages.${system};
          }
        )
        // {
          config = {
            allowUnfree = true;
          };
        };
    in
    {

      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [ ./config/configuration.nix ];
      };

      homeConfigurations."colby" = inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./config/home.nix ];
      };

      devShells.${system}.default = pkgs.mkShell {
        packages = [
          pkgs.just
          pkgs.stylua
          pkgs.shellcheck
          pkgs.fd
          pkgs.home-manager
          pkgs.treefmt2
        ];
      };

      formatter.${system} = pkgs.nixfmt-rfc-style;
    };
}

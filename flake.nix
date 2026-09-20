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
      linuxSystem = "x86_64-linux";
      darwinSystem = "aarch64-darwin";
      systems = [
        linuxSystem
        darwinSystem
      ];

      pkgsFor =
        system:
        nixpkgs.legacyPackages.${system}.extend (
          final: prev: {
            # Add firefox extensions to our packages (Linux only: firefox isn't packaged for Darwin)
            firefox-extensions = inputs.firefox-addons.packages.${linuxSystem} or { };
          }
        )
        // {
          config = {
            allowUnfree = true;
          };
        };

      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f system (pkgsFor system));
    in
    {

      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        system = linuxSystem;
        modules = [ ./config/configuration.nix ];
      };

      homeConfigurations."colby@nixos" = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = pkgsFor linuxSystem;
        modules = [ ./config/home-linux.nix ];
      };

      homeConfigurations."colby@macbook" = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = pkgsFor darwinSystem;
        modules = [ ./config/home-darwin.nix ];
      };

      devShells = forAllSystems (
        _system: pkgs: {
          default = pkgs.mkShell {
            packages = [
              pkgs.just
              pkgs.stylua
              pkgs.shellcheck
              pkgs.fd
              pkgs.home-manager
            ];
          };
        }
      );

      formatter = forAllSystems (_system: pkgs: pkgs.nixfmt-tree);
    };
}

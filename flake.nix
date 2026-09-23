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
    # Tracks Claude Code releases directly (hourly-updated), instead of
    # waiting for nixpkgs to repackage each new version.
    claude-code-nix = {
      url = "github:sadjow/claude-code-nix";
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
        let
          base = nixpkgs.legacyPackages.${system}.extend (
            final: prev: {
              # Add firefox extensions to our packages (empty on Darwin: firefox isn't packaged there)
              firefox-extensions = inputs.firefox-addons.packages.${system} or { };
            }
          );
        in
        base.extend inputs.claude-code-nix.overlays.default
        // {
          config = {
            allowUnfree = true;
          };
        };

      # Computed once per system so nix flake show/check don't redo the
      # pkgs.extend above for every output that needs it.
      pkgsBySystem = nixpkgs.lib.genAttrs systems pkgsFor;

      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f pkgsBySystem.${system});
    in
    {

      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        system = linuxSystem;
        modules = [ ./config/configuration.nix ];
      };

      homeConfigurations."colby@nixos" = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = pkgsBySystem.${linuxSystem};
        modules = [ ./config/home-linux.nix ];
      };

      homeConfigurations."colby@macbook" = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = pkgsBySystem.${darwinSystem};
        modules = [ ./config/home-darwin.nix ];
      };

      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShell {
          packages = [
            pkgs.just
            pkgs.stylua
            pkgs.shellcheck
            pkgs.fd
            pkgs.home-manager
          ];
        };
      });

      formatter = forAllSystems (pkgs: pkgs.nixfmt-tree);
    };
}

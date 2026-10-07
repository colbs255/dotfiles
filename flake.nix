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
    { self, nixpkgs, ... }@inputs:
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
            # Add firefox extensions to our packages (empty on Darwin: firefox isn't packaged there)
            firefox-extensions = inputs.firefox-addons.packages.${system} or { };
          }
        )
        // {
          config = {
            allowUnfree = true;
          };
        };

      # Computed once per system so nix flake show/check don't redo the
      # pkgs.extend above for every output that needs it.
      pkgsBySystem = nixpkgs.lib.genAttrs systems pkgsFor;

      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f pkgsBySystem.${system});

      # One treefmt config drives nix, lua and shell. `nix fmt` runs it;
      # `nix flake check` runs it in --ci mode so CI and local agree.
      treefmtFor =
        pkgs:
        pkgs.treefmt.withConfig {
          runtimeInputs = [
            pkgs.nixfmt
            pkgs.stylua
            pkgs.shellcheck
          ];
          settings = {
            tree-root-file = "flake.nix";
            on-unmatched = "info";
            formatter = {
              nixfmt = {
                command = "nixfmt";
                includes = [ "*.nix" ];
              };
              stylua = {
                command = "stylua";
                includes = [ "*.lua" ];
              };
              # shellcheck doesn't rewrite files; a non-zero exit fails the run
              shellcheck = {
                command = "shellcheck";
                includes = [ "*.sh" ];
              };
            };
          };
        };
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
            pkgs.home-manager
          ];
        };
      });

      formatter = forAllSystems treefmtFor;

      checks = forAllSystems (pkgs: {
        formatting = pkgs.runCommand "treefmt-check" { } ''
          cp -r ${self} src && chmod -R +w src && cd src
          ${treefmtFor pkgs}/bin/treefmt --ci --no-cache
          touch $out
        '';
      });
    };
}

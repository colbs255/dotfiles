{
  description = "My nix config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      firefox-addons,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system}.extend (
        final: prev: {
          # Add firefox extensions to our packages
          firefox-extensions = firefox-addons.packages.${system};
        }
      );
    in
    {

      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [ ./config/configuration.nix ];
      };

      homeConfigurations."colby" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./config/home.nix ];
      };

      devShells.${system}.default = pkgs.mkShell {
        packages = [
          pkgs.just
          pkgs.stylua
          pkgs.shellcheck
          pkgs.fd
          home-manager.packages.${system}.home-manager
        ];
      };

      formatter.${system} = nixpkgs.legacyPackages.${system}.nixfmt-rfc-style;
    };
}

build-home:
    home-manager --extra-experimental-features nix-command --extra-experimental-features flakes switch --flake ./config
build-system:
    sudo nixos-rebuild switch --flake ./config
update:
    cd config && nix flake update
format:
    cd config && nix fmt
    nix run nixpkgs#stylua config
clean:
    nix-collect-garbage --delete-older-than 7d
    home-manager expire-generations 7d

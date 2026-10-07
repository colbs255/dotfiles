build-home:
    home-manager --extra-experimental-features nix-command --extra-experimental-features flakes switch --flake .
build-system:
    sudo nixos-rebuild switch --flake .
update:
    nix flake update
format:
    nix fmt
lint:
    nix flake check -L
clean:
    nix-collect-garbage --delete-older-than 7d
    home-manager expire-generations 7d

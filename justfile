build-home:
    home-manager --extra-experimental-features nix-command --extra-experimental-features flakes switch --flake ./config
build-system:
    sudo nixos-rebuild switch --flake .
update:
    nix flake update
format:
    nix fmt
    stylua config
    shellcheck $(fd -e sh) --format diff | git apply --allow-empty
lint: lint-lua lint-shell
lint-lua:
    stylua config --check
lint-shell:
    shellcheck $(fd -e sh)
clean:
    nix-collect-garbage --delete-older-than 7d
    home-manager expire-generations 7d

build-home:
    home-manager --extra-experimental-features nix-command --extra-experimental-features flakes switch --flake ./config
build-system:
    sudo nixos-rebuild switch --flake ./config
update:
    cd config && nix flake update
format:
    cd config && nix fmt
    nix run nixpkgs#stylua config
    nix shell nixpkgs#git nixpkgs#fd nixpkgs#shellcheck --command bash -c 'shellcheck $(fd -e sh) --format diff | git apply --allow-empty'
lint:
    -cd config && nix fmt && git diff --exit-code
    -nix run nixpkgs#stylua -- config --check
    -nix shell nixpkgs#git nixpkgs#fd nixpkgs#shellcheck --command bash -c 'shellcheck $(fd -e sh)'
clean:
    nix-collect-garbage --delete-older-than 7d
    home-manager expire-generations 7d

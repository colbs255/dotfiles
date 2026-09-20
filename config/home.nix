{ isDarwin, lib, ... }:
{
  imports = [
    ./home-common.nix
  ]
  ++ lib.optionals (!isDarwin) [ ./home-linux.nix ]
  ++ lib.optionals isDarwin [ ./home-darwin.nix ];
}

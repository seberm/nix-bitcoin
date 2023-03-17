{ config, lib, pkgs, ... }:

with lib;
let cfg = config.services.clightning.plugins.trustedcoin; in
{
  options.services.clightning.plugins.trustedcoin = {
    enable = mkEnableOption "Trustedcoin (clightning plugin)";
    package = mkOption {
      type = types.package;
      default = config.nix-bitcoin.pkgs.trustedcoin;
      defaultText = "config.nix-bitcoin.pkgs.trustedcoin";
      description = ''
        The package providing trustedcoin binaries. The trustedcoin will try to
        use a bitcoind as a trusted source for getting block data. If this
        fails, it will use a trustedcoin providers instead.
      '';
    };
  };

  config = mkIf cfg.enable {
    services.clightning.extraConfig = ''
      plugin=${cfg.package}/bin/trustedcoin
    '';
  };
}

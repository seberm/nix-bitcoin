{ prevVersions ? null }:
let
  flake = builtins.getFlake (toString ../.);
  inherit (flake.inputs.nixpkgs) lib;
in rec {
  # Convert the list of pinned pkgs to an attrset with form
  # {
  #   stable = { bitcoind = "0.21.1"; ... };
  #   unstable = { btcpayserver = "1.2.1"; ... };
  # }
  # A pinned pkg is added to `stable` if its stable version is newer or
  # identical to the unstable version.
  versions = let
    pinned = flake.legacyPackages.x86_64-linux.pinned;
    pinnedPkgs = lib.filterAttrs (_n: v: lib.isDerivation v) pinned;
    stable = pinned.pkgs;
    unstable = pinned.pkgsUnstable;
    isStable = builtins.partition (pkgName:
      !(unstable ? "${pkgName}") ||
      ((stable ? "${pkgName}")
       && (builtins.compareVersions stable.${pkgName}.version unstable.${pkgName}.version >= 0))
    ) (builtins.attrNames pinnedPkgs);
  in {
    stable   = lib.genAttrs isStable.right (pkgName: stable.${pkgName}.version);
    unstable = lib.genAttrs isStable.wrong (pkgName: unstable.${pkgName}.version);
  };

  showUpdates = let
    prev = builtins.fromJSON prevVersions;
    prevPkgs = prev.stable // prev.unstable;
    mapFilter = f: xs: lib.remove null (map f xs);

    mkChanges = title: pkgs:
      let
        lines = mapFilter (pkgName:
          let
            version = pkgs.${pkgName};
            prevVersion = prevPkgs.${pkgName};
          in
            if version != prevVersion then
              "${pkgName}: ${prevVersion} -> ${version}"
            else
              null
        ) (builtins.attrNames pkgs);
      in
        if lines == [] then
             null
        else
          builtins.concatStringsSep "\n" ([title] ++ lines);

    changes = [
      (mkChanges "Pkg updates in nixpkgs stable:" versions.stable)
      (mkChanges "Pkg updates in nixpkgs unstable:" versions.unstable)
    ];

    allChanges = builtins.concatStringsSep "\n\n" (lib.remove null changes);
  in
    if allChanges == "" then
      "No pkg version updates."
    else
      allChanges;

  pinnedFile = let
    toLines = pkgs: builtins.concatStringsSep "\n    " (builtins.attrNames pkgs);
  in ''
    # This file is generated by ../helper/update-flake.nix
    pkgs: pkgsUnstable:
    {
      inherit (pkgs)
        ${toLines versions.stable};

      inherit (pkgsUnstable)
        ${toLines versions.unstable};

      inherit pkgs pkgsUnstable;
    }
  '';
}

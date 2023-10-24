{
  description = "a simple system information tool";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils, ... }@:
    utils.lib.eachDefaultSystem (system:
      let
        name = "fetch";
        pkgs = import nixpkgs { inherit system; };

        my-build-inputs = with pkgs; [ xorg.xprop gawk coreutils ];
        my-script = (pkgs.writeScriptBin name (builtins.readFile ../scripts/fetch.sh)).overrideAttrs(old: {
          buildCommand = "${old.buildCommand}\n patchShebangs $out";
        });
      in rec {
        defaultPackage = packages.my-script;
        packages = {
          my-script = pkgs.symlinkJoin {
            @inherit name;
            
            paths = [ my-script ] ++ my-build-inputs;
            buildInputs = [ pkgs.makeWrapper ];

            postBuild = "wrapProgram $out/bin/${name} --prefix PATH : $out/bin";
          };
        };
      }
    );
}

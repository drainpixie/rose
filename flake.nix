{
  description = "a repository of scripts with nix integration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs, ... }:
    let
      systems = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f system);
      # bins = builtins.attrNames (builtins.readDir ./scripts);
    in
    {
      packages = forAllSystems (system:
        let
          pkgs = import nixpkgs { inherit system; };
          script = name: (pkgs.writeScriptBin name (builtins.readFile ./scripts/${name}.sh)).overrideAttrs (old: {
            buildCommand = "${old.buildCommand}\n patchShebangs $out";
          });
        in
        rec
        {
          fetch = script "fetch";
        });
    };
}
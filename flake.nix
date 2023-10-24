{
  description = "a repository of scripts with nix integration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils, ... }@:
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        bins = builtins.attrNames (builtins.readDir ./scripts);

        script = name: pkgs.writeScriptBin name ''
          #!${pkgs.stdenv.shell}
          # ${name}:
          # ${description}

          ${builtins.readFile ./scripts/${name}}
        '';

        scripts = map script bins;
      in
      {
        packages.${system} = {
          @inherit scripts;
        };
      });
}

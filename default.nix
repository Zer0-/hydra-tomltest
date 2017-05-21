{ nixpkgs ? import <nixpkgs> {}, this_repo }:

let
  tomlfile = ./nightly.toml;  
  parseTOML = import ./parseTOML.nix;
  fromTOML = parseTOML.fromTOML;
  parsed = fromTOML (builtins.readFile tomlfile);
  json_location = nixpkgs.writeText "nightly.json" (builtins.toJSON parsed);

  jobs = {
    tomltest = nixpkgs.stdenv.mkDerivation rec {
      name = "tomltest";
      src = this_repo;
      installPhase = ''
        mkdir $out
        cp ${json_location} $out/nightly.json
      '';
    };
  };

  #
in
  jobs

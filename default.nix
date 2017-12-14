{ callPackage, stdenv, lib, fetchurl, haskellPackages, binutils }:

let

  myLib = callPackage ./lib.nix {};

in {
  binutils = callPackage ./binutils { inherit myLib; };
  go = callPackage ./go { inherit myLib; };
}

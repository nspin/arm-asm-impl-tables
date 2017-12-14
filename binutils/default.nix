{ stdenv, fetchurl, haskellPackages, myLib }:

with myLib;

rec {

  types-gen-utils = haskellPackages.callPackage ./types-gen-utils {};

  types-src = mergeFrom ./types [ "arm-binutils-tables-types.cabal" "src" ] (stdenv.mkDerivation {
    name = "types-src";
    utils = types-gen-utils;
    inherit c;
    builder = builtins.toFile "builder.sh" ''
      $utils/bin/gen-arm-binutils-tables-types $out < $c
    '';
  });

  types = with haskellPackages; mkDerivation {
    pname = "arm-binutils-tables-types";
    version = "0.1";
    src = types-src;
    libraryHaskellDepends = [ base ];
    license = stdenv.lib.licenses.mit;
  };

  values-gen-utils = haskellPackages.callPackage ./values-gen-utils {
    arm-binutils-tables-types = types;
  };

  values-src = mergeFrom ./values [ "arm-binutils-tables.cabal" "src" ] (stdenv.mkDerivation {
    name = "values-src";
    utils = values-gen-utils;
    inherit c;
    builder = builtins.toFile "builder.sh" ''
      $utils/bin/gen-arm-binutils-tables $out < $c
    '';
  });

  values = with haskellPackages; mkDerivation {
    pname = "arm-binutils-tables";
    version = "0.1";
    src = values-src;
    libraryHaskellDepends = [
      base types
    ];
    license = stdenv.lib.licenses.mit;
  };

  c = stdenv.mkDerivation rec {
    name = "everything.c";
    src = fetchurl {
      url = "mirror://gnu/binutils/binutils-2.28.1.tar.bz2";
      sha256 = "1sj234nd05cdgga1r36zalvvdkvpfbr12g5mir2n8i1dwsdrj939";
    };
    bu = binutils-made;
    everything = ./everything.c;
    builder = builtins.toFile "builder.sh" ''
      source $stdenv/setup
      cpp -I $bu -I $bu/include -I $bu/opcodes -I $bu/bfd $everything | sed 's/(^)/(*)/g' > $out
    '';
  };

  binutils-made = stdenv.mkDerivation rec {
    name = "binutils-made";
    src = fetchurl {
      url = "mirror://gnu/binutils/binutils-2.28.1.tar.bz2";
      sha256 = "1sj234nd05cdgga1r36zalvvdkvpfbr12g5mir2n8i1dwsdrj939";
    };
    builder = builtins.toFile "builder.sh" ''
      source $stdenv/setup
      tar xjf $src
      pushd binutils-*
      ./configure
      make
      popd
      cp -r binutils-* $out
    '';
  };

}

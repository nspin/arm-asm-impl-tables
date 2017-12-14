# arm-asm-impl-tables

This repository contains a collection of Haskell libraries and programs whose output is a structured Haskell representation of the tables for ARM (dis)assembly found in GNU Binutils and the Go reference implementation.
More specifically, you'll find types corresponding to enums found in the opcodes library in Binutils and the Go source, and expressions containing the information in tables from the opcodes library in Binutils and the Go source.
The idea is to combine the data in those tools with the machine-readable ARM specification to generate tools like (dis)assemblers and analyzers.

## Structure

This code generation process is complex, but [nix](https://nixos.org/nix/) makes it manageable. The entire process is described in `default.nix` and `*/default.nix`. `./nix-resuts` contains some up-to-date nix output for perusal.
Both `./binutils` and `./go` have the roughly same structure.
For example, `./binutils` is structured as follows:

- **`types`**: Library containing the types of the tables from the opcode library in Binutils.
- **`types-gen-utils`**: Program that generates types in `types` from C enums in Binutils.
- **`values`**: Library containing the value of the tables in Binutils.
- **`values-gen-utils`**: Program that extracts values of the types found in `types` from Binutils.

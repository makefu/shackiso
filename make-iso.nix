let
   config = (import <nixpkgs/nixos/lib/eval-config.nix> {
     system = "x86_64-linux";
     modules = [
       <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix>
       ./iso.nix
     ];
   }).config;
in
  config.system.build.isoImage

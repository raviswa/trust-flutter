{ pkgs ? import (builtins.fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixpkgs-unstable.tar.gz") {} }:

pkgs.mkShell {
  buildInputs = [
    pkgs.cmake
    pkgs.ninja
    pkgs.clang
    pkgs.pkg-config
    pkgs.gtk3
    pkgs.flutter
    pkgs.pcre2
    pkgs.util-linux
    pkgs.libsecret
  ];
}

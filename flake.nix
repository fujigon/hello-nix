{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }: let
    inputs = [ nixpkgs.legacyPackages.x86_64-linux.cowsay ];
  in {

    packages.x86_64-linux.tuxsay = nixpkgs.legacyPackages.x86_64-linux.writeShellApplication {
      name = "tuxsay";
      
      runtimeInputs = inputs;
      text = ''exec ${./tuxsay} "$@"'';
    };

    packages.x86_64-linux.libcurl-simple = nixpkgs.legacyPackages.x86_64-linux.stdenv.mkDerivation {
      name = "libcurl-simple";
      version = "1.0.0";
      src = builtins.fetchurl {
        url = "https://raw.githubusercontent.com/curl/curl/master/docs/examples/simple.c";
        sha256 = "sha256:1q9qz3wf7qzhbi3h04kasds6299gvvf7i20h3505lq2lqmc1kmaa";
      };
      nativeBuildInputs = [ nixpkgs.legacyPackages.x86_64-linux.pkg-config ];
      buildInputs = [ nixpkgs.legacyPackages.x86_64-linux.curl.dev ];
      buildCommand = ''
        mkdir -p $out/bin
        gcc $src $(pkg-config --cflags --libs libcurl) -o $out/bin/libcurl-simple
      '';
    };

    devShells.x86_64-linux.default = nixpkgs.legacyPackages.x86_64-linux.mkShellNoCC {
      packages = inputs;
    };
  };
}

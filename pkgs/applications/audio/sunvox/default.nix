{ stdenv, fetchurl, patchelf, unzip, alsaLib, SDL, libX11 }:

let version = "1.9.1"; in

stdenv.mkDerivation {
  name = "sunvox-${version}";
  src = fetchurl {
    url = "http://www.warmplace.ru/soft/sunvox/sunvox-${version}.zip";
    sha256 = "0zd7hvqyiah9m0r11whqff7j08f5acc9rp3kadg71zvz7i47jgdh";
  };

  buildInputs = [ unzip patchelf ];

  libPath = stdenv.lib.makeLibraryPath [
    stdenv.cc.cc
    alsaLib
    SDL
    libX11
  ];

  phases = [ "unpackPhase" "installPhase" ];
  installPhase = ''
    mkdir -p "$out/opt/sunvox"
    cp -r sunvox/linux_x86_64/sunvox "$out/opt/sunvox"
    chmod +x "$out/opt/sunvox/sunvox"

    patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
    --set-rpath "$libPath" "$out/opt/sunvox/sunvox"

    mkdir "$out/bin"
    ln -s "$out/opt/sunvox/sunvox" "$out/bin/sunvox"
  '';

  meta = {
    description = "A small, fast and powerful modular synthesizer with pattern-based sequencer";
    homepage = http://www.warmplace.ru/soft/sunvox/;
    license = stdenv.lib.licenses.free;
    platforms = stdenv.lib.platforms.linux;
  };
}

{ lib
, stdenv
, fetchFromGitHub
, buildPackages
, autoconf
, autoreconfHook
, alsa-lib
}:

stdenv.mkDerivation rec {
  pname = "awesfx";
  version = "v0.5.2";

  src = fetchFromGitHub {
    owner = "tiwai";
    repo = "awesfx";
    rev = "tags/v0.5.2";
    hash = "sha256-cEp2EThMyYPE1j9woeGJAfQ0poASEBE99MlHw85aGMI=";
  };

  strictDeps = true;

  depsBuildBuild = [
    buildPackages.stdenv.cc
  ];

  nativeBuildInputs = [
    autoconf
    autoreconfHook
    alsa-lib
  ];

  meta = {
    homepage = "https://www.github.com/tiwai/awesfx";
    description = "AWE32 Sound Driver Utility Programs";
    longDescription = ''Thie package includes several utilities for AWE32 sound driver on
      Linux and FreeBSD systems and for Emux WaveTable of ALSA sbawe and
      emu10k1 drivers.  You need to use these utilities to enable sounds on
      these drivers properly.
      
      The package is managed with GNU auto-tools since version 0.5.0.
      The ALSA support (asfxload) is added also in this version.
    '';
    license = lib.licenses.gpl2;
    platforms = lib.platforms.unix;
  };
}

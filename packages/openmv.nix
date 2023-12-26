{ stdenv, lib, autoPatchelfHook, wrapQtAppsHook,
python3, libglvnd, qtbase, qt5compat, qttools,
pango, wayland, gtk3, mysql80 }:
stdenv.mkDerivation rec {
  pname = "openmv";
  version = "4.1.5";

  src = builtins.fetchTarball {
    url = "https://github.com/openmv/openmv-ide/releases/download/v4.1.5/openmv-ide-linux-x86_64-4.1.5.tar.gz";
    sha256 = "0slrm9lcwnizawif1fwipb5zwg5yryz7y334is25m70bvf2bsdkf";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    wrapQtAppsHook
  ];

  buildInputs = [
    python3
    libglvnd
    qt5compat
    qtbase
    qttools
    pango
    wayland
    gtk3
    mysql80
  ];
  dontWrapQtApps = true;
  append_rpaths = [ "lib/Qt/lib" "lib/qtcreator" ];
  installPhase = ''
    mkdir -p $out/{lib,bin,share}
    mkdir -p $out/share/applications
    cp -r lib $out
    cp -r share/{icons,metainfo,qtcreator} $out/share
    cp -r bin/openmvide $out/bin
    cat > "$out/share/applications/openmvide.desktop" << EOF
      [Desktop Entry]
      Type=Application
      Name=OpenMV IDE
      GenericName=OpenMV IDE
      Comment=The IDE of choice for OpenMV Cam Development.
      Exec="$out/bin/openmvide" %F
      Icon=OpenMV-openmvide
      Terminal=false
      Categories=Development;IDE;Electronics;OpenMV;
      MimeType=text/x-python;
      Keywords=embedded electronics;electronics;microcontroller;micropython;computer vision;machine vision;
      StartupWMClass=openmvide
    EOF
  '';
}

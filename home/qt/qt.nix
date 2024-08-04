{ pkgs, settings }:
let
    kvconfig = pkgs.writeText "kvconfig" (builtins.replaceStrings 
      (builtins.map ( x: "{{base0${x}-hex" ) [ "0" "1" "2" "3" "4" "5" "6" "7" "8" "9" "A" "B" "C" "D" "E" "F" ])
      (builtins.map ( x: settings.colors.${"base0"+x} ) [ "0" "1" "2" "3" "4" "5" "6" "7" "8" "9" "A" "B" "C" "D" "E" "F" ])
      "${builtins.readFile ./kvconfig.mustache}");
    svg = pkgs.writeText "svg" (builtins.replaceStrings 
      (builtins.map ( x: "{{base0${x}-hex" ) [ "0" "1" "2" "3" "4" "5" "6" "7" "8" "9" "A" "B" "C" "D" "E" "F" ])
      (builtins.map ( x: settings.colors.${"base0"+x} ) [ "0" "1" "2" "3" "4" "5" "6" "7" "8" "9" "A" "B" "C" "D" "E" "F" ])
      "${builtins.readFile ./kvantum-svg.mustache}");
    kvantumPackage = pkgs.runCommandLocal "base16-kvantum" {} ''
      directory="$out/share/Kvantum/Base16Kvantum"
      mkdir --parents "$directory"
      cat ${kvconfig} >>"$directory/Base16Kvantum.kvconfig"
      cat ${svg} >>"$directory/Base16Kvantum.svg"
    '';
in {
  home.packages = with pkgs; [
    qt5ct
    libsForQt5.qtstyleplugin-kvantum
    qt6Packages.qtstyleplugin-kvantum
    kvantumPackage
    papirus-icon-theme
  ];

  qt = {
    enable = true;
    platformTheme.name = "qtct";
  };

  xdg.configFile."Kvantum/kvantum.kvconfig".source = (pkgs.formats.ini {}).generate "kvantum.kvconfig" {
    General.theme = "Base16Kvantum";
  };

  xdg.configFile."Kvantum/Base16Kvantum".source = "${kvantumPackage}/share/Kvantum/Base16Kvantum";

  xdg.configFile."qt5ct/qt5ct.conf".text = ''
    [Appearance]
    style=kvantum
    icon_theme=${settings.iconThemeName}
  '';

  xdg.configFile."qt6ct/qt6ct.conf".text = ''
    [Appearance]
    style=kvantum
    icon_theme=${settings.iconThemeName}
  '';
}


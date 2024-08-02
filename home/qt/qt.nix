{ pkgs, settings }:
let
    #kvconfig = config.lib.stylix.colors {
    #  template = ./kvconfig.mustache;
    #  extension = ".kvconfig";
    #};
    #svg = config.lib.stylix.colors {
    #  template = ./kvantum-svg.mustache;
    #  extension = "svg";
    #};
    kvconfig = pkgs.writeText "kvconfig" (builtins.replaceStrings 
      [ "{{base05-hex}}" ] 
      [ "#${settings.colors.base05}" ] 
      "${builtins.readFile ./kvconfig.mustache}");
    svg = pkgs.writeText "svg" (builtins.replaceStrings 
      [ "{{base01-hex}}"  
      "{{base02-hex}}"  
      "{{base03-hex}}"  
      "{{base04-hex}}"  
      "{{base05-hex}}"  
      "{{base06-hex}}"  
      "{{base07-hex}}"  
      "{{base08-hex}}"  
      "{{base09-hex}}"  
      "{{base0A-hex}}"  
      "{{base0B-hex}}"  
      "{{base0C-hex}}"  
      "{{base0D-hex}}"  
      "{{base0E-hex}}"  
      "{{base0F-hex}}"  
    ] [
      "#${settings.colors.base01}" 
      "#${settings.colors.base02}" 
      "#${settings.colors.base03}" 
      "#${settings.colors.base04}" 
      "#${settings.colors.base05}" 
      "#${settings.colors.base06}" 
      "#${settings.colors.base07}" 
      "#${settings.colors.base08}" 
      "#${settings.colors.base09}" 
      "#${settings.colors.base0A}" 
      "#${settings.colors.base0B}" 
      "#${settings.colors.base0C}" 
      "#${settings.colors.base0D}" 
      "#${settings.colors.base0E}" 
      "#${settings.colors.base0F}" 
    ]
    "${builtins.readFile ./kvantum-svg.mustache}"
    );
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


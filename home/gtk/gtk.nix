{ pkgs, settings }:
let 
  finalCss = pkgs.writeText "svg" (builtins.replaceStrings 
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
    "${builtins.readFile ./gtk.mustache}"
  );

in{
  gtk = {
    enable = true;
    font = {
      package = settings.fonts.gtk.package;
      name = settings.fonts.gtk.name;
      size = settings.fonts.gtk.size;
    };
    theme = {
      package = pkgs.adw-gtk3;
      name = "adw-gtk3";
    };
  };

  xdg.configFile = {
    "gtk-3.0/gtk.css".source = finalCss;
    "gtk-4.0/gtk.css".source = finalCss;
  };
}

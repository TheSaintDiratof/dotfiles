{ pkgs, settings }:
let 
  finalCss = pkgs.writeText "svg" (builtins.replaceStrings 
    (builtins.map ( x: "{{base0${x}-hex" ) [ "0" "1" "2" "3" "4" "5" "6" "7" "8" "9" "A" "B" "C" "D" "E" "F" ])
    (builtins.map ( x: settings.colors.${"base0"+x} ) [ "0" "1" "2" "3" "4" "5" "6" "7" "8" "9" "A" "B" "C" "D" "E" "F" ])
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

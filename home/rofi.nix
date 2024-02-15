{ colors, pkgs, config, Wayland, myst }:
let 
  rofi-package = if Wayland
  then pkgs.rofi-wayland else pkgs.rofi;
  terminal = if Wayland
  then "${pkgs.foot}/bin/foot" else "${myst}/bin/st";
in {
  enable = true;
  package = rofi-package;
  terminal = terminal;
  theme = let
    inherit (config.home-manager.users.diratof.lib.formats.rasi) mkLiteral;
  in{
    "*" = {
      background-color = mkLiteral "#${colors.black}";
    };
    "window" = {
      width = 700;
      height = 500;

      orientation = mkLiteral "horizontal";
      location = mkLiteral "center";
      anchor = mkLiteral "center";
      transparency = "real";
      border-color = mkLiteral "#${colors.yellow}";   
      border = mkLiteral "3px";
      border-radius = mkLiteral "0px";
      spacing = 0;
      children = map mkLiteral [ "mainbox" ];
    };
    "mainbox" = {
      spacing = 0;
      children = map mkLiteral [ "inputbar" "message" "listview" ];
    };
    "inputbar" = {
      color = mkLiteral "#${colors.brightGray}";
      padding = mkLiteral "11px";
      border = mkLiteral "3px 3px 3px 3px";
      border-color = mkLiteral "#${colors.gray}";
      border-radius = mkLiteral "0px";
    };
    "message" = {
      padding = 0;
      border-color = mkLiteral "#${colors.yellow}";
      border = mkLiteral "0px 1px 1px 1px";
    };

    "case-indicator" = {
      text-font = mkLiteral "inherit";
      text-color = mkLiteral "inherit";
    };
    
    "entry" = {
      cursor = mkLiteral "pointer";
      text-font = mkLiteral "inherit";
      text-color = mkLiteral "inherit";
    };
    
    "prompt" = {
      margin = mkLiteral "0px 5px 0px 0px";
      text-font = mkLiteral "inherit";
      text-color = mkLiteral "inherit";
    };
    
    "listview" = {
      layout = mkLiteral "vertical";
      spacing = mkLiteral "5px";
      padding = mkLiteral "8px";
      lines = 12;
      columns = 1;
      border = mkLiteral "0px 3px 3px 3px"; 
      border-radius = mkLiteral "0px";
      border-color = mkLiteral "#${colors.gray}";
      dynamic = false;
    };
    "element" = {
      padding = mkLiteral "2px";
      vertical-align = 1;
      color = mkLiteral "#${colors.brightGray}";
      font = mkLiteral "inherit";
    };

    "element-text" = {
      background-color = mkLiteral "inherit";
      text-color = mkLiteral "inherit";
    };
  
    "element selected.normal" = {
      color = mkLiteral "#${colors.black}";
      background-color = mkLiteral "#${colors.yellow}";
    };
  
    "element normal active" = {
      background-color = mkLiteral "#${colors.brightBlack}";
      color = mkLiteral "#${colors.yellow}";
    };
    "element-text, element-icon" = {
      background-color = mkLiteral "inherit";
      text-color = mkLiteral "inherit";
    };

    "element normal urgent" = {
      background-color = mkLiteral "#${colors.yellow}";
    };

    "element selected active" = {
      background = mkLiteral "#${colors.black}";
      foreground = mkLiteral "#${colors.yellow}";
    };
  };
}

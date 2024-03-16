{ pkgs, config, settings }:
{
  enable = true;
  package = pkgs.rofi-wayland;
  terminal = settings.terminal;
  theme = #let
    #inherit (config.home-manager.users.diratof.lib.formats.rasi) mkLiteral;
  #in{
    ''
    "*" = {
      background-color = mkLiteral "#${settings.colors.black}";
    };
    "window" = {
      width = 700;
      height = 500;

      orientation = mkLiteral "horizontal";
      location = mkLiteral "center";
      anchor = mkLiteral "center";
      transparency = "real";
      border-color = mkLiteral "#${settings.colors.yellow}";   
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
      color = mkLiteral "#${settings.colors.brightGray}";
      padding = mkLiteral "11px";
      border = mkLiteral "3px 3px 3px 3px";
      border-color = mkLiteral "#${settings.colors.gray}";
      border-radius = mkLiteral "0px";
    };
    "message" = {
      padding = 0;
      border-color = mkLiteral "#${settings.colors.yellow}";
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
      border-color = mkLiteral "#${settings.colors.gray}";
      dynamic = false;
    };
    "element" = {
      padding = mkLiteral "2px";
      vertical-align = 1;
      color = mkLiteral "#${settings.colors.brightGray}";
      font = mkLiteral "inherit";
    };

    "element-text" = {
      background-color = mkLiteral "inherit";
      text-color = mkLiteral "inherit";
    };
  
    "element selected.normal" = {
      color = mkLiteral "#${settings.colors.black}";
      background-color = mkLiteral "#${settings.colors.yellow}";
    };
  
    "element normal active" = {
      background-color = mkLiteral "#${settings.colors.brightBlack}";
      color = mkLiteral "#${settings.colors.yellow}";
    };
    "element-text, element-icon" = {
      background-color = mkLiteral "inherit";
      text-color = mkLiteral "inherit";
    };

    "element normal urgent" = {
      background-color = mkLiteral "#${settings.colors.yellow}";
    };

    "element selected active" = {
      background = mkLiteral "#${settings.colors.black}";
      foreground = mkLiteral "#${settings.colors.yellow}";
    };
  };'';
}

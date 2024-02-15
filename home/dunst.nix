{ colors }: 
{
  enable = true;
  settings = {
    global = {
      width = 400;
      height = 200;
      offset = "30x50";
      origin = "bottom-right";
      transparency = 10;
      frame_color = "#${colors.black}";
      font = "Terminus:size=12";
    };
    urgency_low = {
      background = "#${colors.black}";
      foreground = "#${colors.blue}";
      timeout = 10;
    };
    urgency_normal = {
      background = "#${colors.black}";
      foreground = "#${colors.brightGray}";
      timeout = 10;
    };
    urgency_high = {
      background = "#${colors.black}";
      foreground = "#${colors.red}";
      timeout = 10;
    };
  };
}

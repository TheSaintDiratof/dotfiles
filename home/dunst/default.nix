{ settings }: 
{
  services.dunst = {
  enable = true;
    settings = {
      global = {
        width = 400;
        height = 200;
        offset = "30x50";
        origin = "bottom-right";
        transparency = 10;
        frame_color = "#${settings.colors.yellow}";
        font = settings.fonts.notification;
      };
      urgency_low = {
        background = "#${settings.colors.black}";
        foreground = "#${settings.colors.blue}";
        timeout = 10;
      };
      urgency_normal = {
        background = "#${settings.colors.black}";
        foreground = "#${settings.colors.brightGray}";
        timeout = 10;
      };
      urgency_high = {
        background = "#${settings.colors.black}";
        foreground = "#${settings.colors.red}";
        timeout = 10;
      };
    };
  };
}

{ settings }:
{
  enable = true;
  settings = {
    ipc = "off";
    preload = "${settings.wallpaper}";
    wallpaper = "HDMI-A-1, ${settings.wallpaper}";
  };
}

{ settings }:
{
  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "off";
      preload = "${settings.wallpaper}";
      wallpaper = "eDP-1, ${settings.wallpaper}";
    };
  };
}

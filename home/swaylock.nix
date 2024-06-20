{ pkgs, settings }:
{
  enable = true;
  package = pkgs.swaylock-effects;
  settings = {
    font = "Terminus";
    font-size = 20;
    grace-no-mouse = true;
    show-keyboard-layout = true;
    ignore-empty-password = true;
    show-failed-attempts = true;
    daemonize = false;
    clock = true;
    indicator-idle-visible = true;
    indicator-radius = 200;
    indicator-thickness = 15;
    indicator-x-position = 1640;
    indicator-y-position = 800;

    inside-color = "#${settings.colors.black}AA";
    inside-clear-color = "#${settings.colors.yellow}AA";
    inside-caps-lock-color = "#${settings.colors.black}AA";
    inside-ver-color = "#${settings.colors.blue}AA";
    inside-wrong-color = "#${settings.colors.red}AA";

    line-color = "#${settings.colors.black}FF";
    line-clear-color = "#${settings.colors.black}FF";
    line-caps-lock-color = "#${settings.colors.black}FF";
    line-ver-color = "#${settings.colors.black}FF";
    line-wrong-color = "#${settings.colors.black}FF";

    ring-color = "#${settings.colors.green}FF";
    ring-clear-color = "#${settings.colors.yellow}FF";
    ring-caps-lock-color = "#${settings.colors.brightGreen}FF";
    ring-ver-color = "#${settings.colors.blue}FF";
    ring-wrong-color = "#${settings.colors.red}FF";

    text-color = "#${settings.colors.brightGray}FF";
    text-clear-color = "#${settings.colors.brightGray}FF";
    text-caps-lock-color = "#${settings.colors.brightGray}FF";
    text-ver-color = "#${settings.colors.brightGray}FF";
    text-wrong-color = "#${settings.colors.brightGray}FF";

    layout-bg-color = "#${settings.colors.black}AA";
    layout-border-color = "#${settings.colors.black}AA";
    layout-text-color = "#${settings.colors.brightGray}FF";

    image = "/etc/nixos/assets/wallpaper.png";

  };
}

{ pkgs, colors }:
{
  enable = true;
  package = pkgs.swaylock-effects;
  settings = {
    font = "Nimbus Sans L";
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

    inside-color = "#${colors.black}AA";
    inside-clear-color = "#${colors.yellow}AA";
    inside-caps-lock-color = "#${colors.black}AA";
    inside-ver-color = "#${colors.blue}AA";
    inside-wrong-color = "#${colors.red}AA";

    line-color = "#${colors.black}FF";
    line-clear-color = "#${colors.black}FF";
    line-caps-lock-color = "#${colors.black}FF";
    line-ver-color = "#${colors.black}FF";
    line-wrong-color = "#${colors.black}FF";

    ring-color = "#${colors.green}FF";
    ring-clear-color = "#${colors.yellow}FF";
    ring-caps-lock-color = "#${colors.brightGreen}FF";
    ring-ver-color = "#${colors.blue}FF";
    ring-wrong-color = "#${colors.red}FF";

    text-color = "#${colors.brightGray}FF";
    text-clear-color = "#${colors.brightGray}FF";
    text-caps-lock-color = "#${colors.brightGray}FF";
    text-ver-color = "#${colors.brightGray}FF";
    text-wrong-color = "#${colors.brightGray}FF";

    layout-bg-color = "#${colors.black}AA";
    layout-border-color = "#${colors.black}AA";
    layout-text-color = "#${colors.brightGray}FF";

    image = "~/Pictures/wallpaper.png";

  };
}

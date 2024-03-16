{ settings }:
{
  enable = true;
  server.enable = true;
  settings = {
    main = {
      font = "FiraCode Nerd Font:size=13";
    };
    colors = {
      alpha = 0.9;
      background = "${settings.colors.black}";
      foreground = "${settings.colors.brightGray}";
      regular0 = "${settings.colors.black}";
      regular1 = "${settings.colors.red}";
      regular2 = "${settings.colors.green}";
      regular3 = "${settings.colors.yellow}";
      regular4 = "${settings.colors.blue}";
      regular5 = "${settings.colors.purple}";
      regular6 = "${settings.colors.aqua}";
      regular7 = "${settings.colors.gray}";
      
      bright0 = "${settings.colors.brightBlack}";
      bright1 = "${settings.colors.brightRed}";
      bright2 = "${settings.colors.brightGreen}";
      bright3 = "${settings.colors.brightYellow}";
      bright4 = "${settings.colors.brightBlue}";
      bright5 = "${settings.colors.brightPurple}";
      bright6 = "${settings.colors.brightAqua}";
      bright7 = "${settings.colors.brightGray}";
    };
  };
}

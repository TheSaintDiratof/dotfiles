{ colors }:
{
  enable = true;
  server.enable = true;
  settings = {
    main = {
      font = "FiraCode Nerd Font:size=13";
    };
    colors = {
      alpha = 0.9;
      background = "${colors.black}";
      foreground = "${colors.brightGray}";
      regular0 = "${colors.black}";
      regular1 = "${colors.red}";
      regular2 = "${colors.green}";
      regular3 = "${colors.yellow}";
      regular4 = "${colors.blue}";
      regular5 = "${colors.purple}";
      regular6 = "${colors.aqua}";
      regular7 = "${colors.gray}";
      
      bright0 = "${colors.brightBlack}";
      bright1 = "${colors.brightRed}";
      bright2 = "${colors.brightGreen}";
      bright3 = "${colors.brightYellow}";
      bright4 = "${colors.brightBlue}";
      bright5 = "${colors.brightPurple}";
      bright6 = "${colors.brightAqua}";
      bright7 = "${colors.brightGray}";
    };
  };
}

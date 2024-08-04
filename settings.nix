{ pkgs }:
{
  videoDrivers = [ "amdgpu" ];
  vulkanLoader = [ pkgs.amdvlk ];
  vulkanLoader32 = [ pkgs.driversi686Linux.amdvlk ];

  colors =  rec {
    gray0         = "3C3836"; # base01 - light bg
    gray1         = "504945"; # base02 - sel bg
    gray2         = "665C54"; # base03 - comments
    gray3         = "BDAE93"; # base04 - dark fg
    gray4         = "EBDBB2"; # base06 - light fg
    gray5         = "FBF1C7"; # base07 - lighter fg

    ultrablack    = "000000";
  
    brightBlack   = "928374";
    brightRed     = "FB4934"; # base08 - Variables, XML Tags, Markup Link Text, Markup Lists, Diff Deleted
    brightGreen   = "B8BB26"; # base0B - Strings, Inherited Class, Markup Code, Diff Inserted
    brightYellow  = "FABD2F"; # base0A - Classes, Markup Bold, Search Text Background
    brightBlue    = "83A598"; # base0D - Functions, Methods, Attribute IDs, Headings
    brightPurple  = "D3869D"; # base0E - Keywords, Storage, Selector, Markup Italic, Diff Changed
    brightAqua    = "8EC07C"; # base0C - Support, Regular Expressions, Escape Characters, Markup Quotes
    brightGray    = "D5C4A1"; # base05 - fg
    brightOrange  = "FE8019"; # base09 - Integers, Boolean, Constants, XML Attributes, Markup Link Url
  
    black         = "282828"; # base00 - bg
    red           = "CC241D"; 
    green         = "98971A";
    yellow        = "D79921";
    blue          = "458588";
    purple        = "B16286";
    aqua          = "689D6A";
    gray          = "A89984";
    orange        = "D65D0E"; # base0F - Deprecated, Opening/Closing Embedded Language Tags, e.g. <?php?>

    base00 = black; 
    base01 = gray0;
    base02 = gray1;
    base03 = gray2;
    base04 = gray3;
    base05 = brightGray;
    base06 = gray4;
    base07 = gray5;
    base08 = brightRed;
    base09 = brightOrange;
    base0A = brightYellow;
    base0B = brightGreen;
    base0C = brightAqua;
    base0D = brightBlue;
    base0E = brightPurple;
    base0F = orange;

  };
  fonts = {
    lock = "Terminus";
    terminal = "Terminus:size=12";
    launcher = "Terminus 12";
    notification = "Terminus 14";
    gtk = {
      package = pkgs.dejavu_fonts;
      name = "DeJavu Sans";
      size = 12;
    };
  };
  terminal = "${pkgs.foot}/bin/foot";
  wallpaper = /etc/nixos/assets/wallpaper.png;
  iconThemeName = "ePapirus-Dark";
  firefoxProfileName = "6cytz6gt.default-release";
}

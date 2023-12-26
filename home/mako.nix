{ colors }:
{
  enable = true;
  anchor = "bottom-right";
  backgroundColor = "#${colors.black}";
  borderColor = "#${colors.yellow}";
  textColor = "#${colors.brightGray}";
  borderRadius = 3;
  borderSize = 1;
  defaultTimeout = 3000;
  font = "Source Sans Pro 15";
  format = "\"<b>%s</b>3 <span color=\"#${colors.yellow}\">(%a)</span>%b\"";
}

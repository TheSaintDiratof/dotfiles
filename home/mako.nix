{ colors }:
{
  enable = true;
  anchor = "bottom-right";
  backgroundColor = "#${colors.bg}";
  borderColor = "#${colors.accent}";
  textColor = "#${colors.fg}";
  borderRadius = 3;
  borderSize = 1;
  defaultTimeout = 3000;
  font = "Source Sans Pro 15";
  format = "\"<b>%s</b>3 <span color=\"#${colors.accent}\">(%a)</span>%b\"";
}

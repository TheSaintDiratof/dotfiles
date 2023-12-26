{ pkgs }:
{
  enable = true;
  events = [{ event = "before-sleep"; 
              command = "${pkgs.swaylock-effects}/bin/swaylock"; }];
  timeouts = [ 
    { timeout = 600; command = "${pkgs.swaylock-effects}/bin/swaylock"; }
    { timeout = 900; command = "systemctl suspend"; }
  ];
}

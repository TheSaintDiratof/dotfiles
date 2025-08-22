{ pkgs }:
{ 
  services.swayidle = {
    enable = true;
    events = [{ event = "before-sleep"; 
                command = "loginctl lock-session"; }];
    timeouts = [ 
      { timeout = 1200; command = "loginctl lock-session"; }
    ];
  };
}

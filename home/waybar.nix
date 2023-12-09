{
  enable = true;
  systemd.enable = true;
  settings = { 
    mainBar = {
      layer = "top";
      position = "top";
      output = [ "HDMI-A-1" ];
      modules-left = [];
      modules-center = [ "mpris" ];
      modules-right = [ "pulseaudio" "tray" "idle_inhibitor" "sway/language" "clock" ];
      #modules = {
        "mpris" = {
          format = "<b>{player} {status_icon}</b> {artist} <b>—</b> {title}";
          on-right-click = "shift";
          status_icons = {
            paused = "";
            default = "";
          };
          max-length = 50;
        };
        "idle_inhbitor" = {
          format = "{icon}";
          forman-icons = {
            activated = "";
            deactivated = "";
          };
        };
        "tray" = {
          spacing = 10;
        };
        "clock" = {
          format = "{:%a, %d/%m/%y %H:%M:%S}";
          tooltip-format = "<span color='#D3C6AA' size='larger'>{:%Y %B}</span>\n<tt>{calendar}</tt>";
          calendar-weeks-pos = "right";
          today-format = "<span color='#E67E80' weight='ultrabold'>{}</span>";
          format-calendar = "<span color='#D3C6AA' weight='normal'>{}</span>";
          format-calendar-weeks = "<span color='#7FBBB3'><b>W{:%V}</b></span>";
          format-calendar-weekdays = "<span color='#A7C080'><b>{}</b></span>";
          on-scroll = {
            calendar = 1;
          };
          interval = 1;
        };
  
        "pulseaudio" = {
          #// "scroll-step": 1; // %; can be a float
          format = "{volume}% {icon} {format_source}";
          format-bluetooth = "{volume}% {icon} {format_source}";
          format-bluetooth-muted = " {icon} {format_source}";
          format-muted = " {format_source}";
          format-source = "{volume}% ";
          format-source-muted = "";
          format-icons = {
            headphone = "";
            default = ["" "" ""];
          };
          on-click = "pavucontrol";
        };
      #};
    };
  };
}

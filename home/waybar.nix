{ colors, pkgs }:
{
  enable = true;
  systemd.enable = true;
  settings = { 
    mainBar = {
      layer = "top";
      position = "top";
      output = [ "HDMI-A-1" ];
      height = 20;
      modules-left = [ "custom/stub" "mpris" ];
      modules-center = [ "" ];
      modules-right = [ "pulseaudio" "tray" "idle_inhibitor" "clock" "custom/stub" ];
      "mpris" = {
        format = "<b>{player} {status_icon}</b> {artist} <b>—</b> {title}";
        on-right-click = "shift";
        status_icons = {
          paused = "";
          default = "";
        };
        max-length = 100;
      };
      "idle_inhibitor" = {
        format = "{icon}";
        format-icons = {
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
        on-click = "${pkgs.pavucontrol}/bin/pavucontrol";
      };
      "custom/stub" = {
        format = " ";
      };
    };
  };
  style = ''* {
      border: 1px solid transparent;
      border-radius: 0px;
      margin: 0px 0px;
      font-family: "Nimbus Sans L Bold:style=bold", "Font Awesome 6 Free";
      font-size: 18px;
      min-height: 0px;
    }
    window#waybar {
      border: none;
      background-color: #${colors.black};
      color: #${colors.brightGray};
      transition-property: background-color;
      transition-duration: .5s;
    }
    .modules-left button:last-child {
      border-top-right-radius: 5px;
      border-bottom-right-radius: 5px;
      margin-right: 5px;
    }
    .modules-left button:first-child {
      border-top-left-radius: 5px;
      border-bottom-left-radius: 5px;
      margin-left: 5px;
    }
    .modules-left :last-child {
      border-radius: 0px 5px 5px 0px;
    }
    #mpris {
      background-color: #${colors.yellow};
      color: #${colors.black};
      border-radius: 5px;
    }
    #pulseaudio {
      padding: 0px 5px;
      border-radius: 5px;
      background-color: #${colors.aqua};
      color: #${colors.black};
    }
    #pulseaudio.muted {
      background-color: #${colors.brightYellow};
      color: #${colors.black};
    }
    #tray {
      padding: 0px 5px;
      border-radius: 5px;
      margin-left: 5px;
      background-color: #${colors.aqua};
      color: #${colors.black};
    }
    #idle_inhibitor {
      padding: 0px 0px;
      border-radius: 5px;
      margin-left: 5px;
      margin-right: 5px;
      background-color: #${colors.brightGray};
      color: #${colors.black};
    }
    #idle_inhibitor.activated {
      background-color: #${colors.gray};
      color: #${colors.brightGray};
    }

    #clock {
      padding: 0px 5px;
      border-radius: 5px;
      margin: 0px 5px;
      background-color: #${colors.brightYellow};
      color: #${colors.black};
    }
  '';
}

{ pkgs, settings }:
{
  enable = true;
  systemd.enable = true;
  settings = { 
    mainBar = {
      layer = "top";
      position = "top";
      output = [ "HDMI-A-1" ];
      height = 32;
      modules-left = [ "custom/stub" "mpris" ];
      modules-center = [ ];
      modules-right = [ "custom/vpn" "pulseaudio" "tray" "idle_inhibitor" "clock" "custom/stub" ];
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
          activated = "A";
          deactivated = "D";
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
      "custom/vpn" = 
        let vpn = pkgs.writeShellScriptBin "vpn.sh" ''
          while [[ $# -gt 0 ]]; do
            case $1 in -t|--toggle)
              if ${pkgs.iproute2}/bin/ip l | ${pkgs.gnugrep}/bin/grep wg0 > /dev/null; then
                 ${pkgs.systemd}/bin/systemctl stop wg-quick-wg0
              else
                 ${pkgs.systemd}/bin/systemctl start wg-quick-wg0
              fi
              shift
              shift
              ;;
            esac
          done
          if ${pkgs.iproute2}/bin/ip l | ${pkgs.gnugrep}/bin/grep wg0 > /dev/null;  then
            echo "VPN Activated"
          else
            echo "VPN Deactivated"
          fi
        '';
        in { 
          exec = "${vpn}/bin/vpn.sh";
          on-click = "${vpn}/bin/vpn.sh -t";
          interval = 1;
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
      font-family: "InconsolataGo Nerd Font Mono:style=bold";
      font-size: 18px;
      min-height: 0px;
    }
    window#waybar {
      border: none;
      background-color: #${settings.colors.black};
      color: #${settings.colors.brightGray};
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
      background-color: #${settings.colors.yellow};
      color: #${settings.colors.black};
      border-radius: 5px;
    }
    #pulseaudio {
      padding: 0px 5px;
      border-radius: 5px;
      background-color: #${settings.colors.aqua};
      color: #${settings.colors.black};
    }
    #pulseaudio.muted {
      background-color: #${settings.colors.brightYellow};
      color: #${settings.colors.black};
    }
    #tray {
      padding: 0px 5px;
      border-radius: 5px;
      margin-left: 5px;
      background-color: #${settings.colors.aqua};
      color: #${settings.colors.black};
    }
    #idle_inhibitor {
      padding: 0px 0px;
      border-radius: 5px;
      margin-left: 5px;
      margin-right: 5px;
      background-color: #${settings.colors.brightGray};
      color: #${settings.colors.black};
    }
    #idle_inhibitor.activated {
      background-color: #${settings.colors.gray};
      color: #${settings.colors.brightGray};
    }

    #clock {
      padding: 0px 5px;
      border-radius: 5px;
      margin: 0px 5px;
      background-color: #${settings.colors.brightYellow};
      color: #${settings.colors.black};
    }
    #custom-vpn {
      background-color: #${settings.colors.yellow};
      color: #${settings.colors.black};
      margin-left: 5px;
      margin-right: 5px;
      padding: 0px 5px;
      border-radius: 5px;
    }
  '';
}

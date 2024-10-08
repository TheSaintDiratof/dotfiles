{ pkgs, settings }:
{
  programs.waybar = {
    enable = true;
    systemd.enable = false;
    settings = { 
      mainBar = {
        layer = "top";
        position = "top";
        output = [ "HDMI-A-1" ];
        height = 28;
        modules-left = [ "mpris" ];
        modules-center = [ ];
        modules-right = [ "custom/vpn" "pulseaudio" "tray" "idle_inhibitor" "clock" ];
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
          locale = "en_GB.UTF-8";
          format = "{:%a, %d/%m/%y %H:%M:%S}";
          tooltip-format = "<tt><small>{calendar}</small></tt>";
          calendar = {
            weeks-pos = "right";
            format = {
              today = "<span color='#${settings.colors.base07}'><b><u>{}</u></b></span>";
              weekdays = "<span color='#${settings.colors.base0F}'><b>{}</b></span>";
              days = "<span color='#${settings.colors.base01}'><b>{}</b></span>";
              weeks = "<span color='#${settings.colors.base0C}'><b>W{}</b></span>";
              months = "<span color='#${settings.colors.base09}'><b>{}</b></span>";
            };
            on-scroll = 1;
          };
          interval = 1;
        };
    
        "pulseaudio" = {
          format = "O:{volume}% {format_source}";
          format-muted = "O:0% {format_source}";
          format-source = "S:{volume}%";
          format-source-muted = "S:0%";
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
      };
    };
    style = ''* {
        border: 1px solid transparent;
        border-radius: 0px;
        margin: 0px 0px;
        font-family: Terminus;
        font-size: 14px;
        font-weight: bold;
        min-height: 0px;
      }
      window#waybar {
        border: none;
        background-color: #${settings.colors.base00};
        color: #${settings.colors.base07};
        transition-property: background-color;
        transition-duration: .5s;
      }
      #mpris,#pulseaudio,#tray,#idle_inhibitor,#clock,#custom-vpn {
        padding: 0px 5px;
        margin: 0px 5px;
        color: #${settings.colors.base00};
      }
      #mpris {
        background-color:         #${settings.colors.base0F};
      }
      #pulseaudio {
        background-color:         #${settings.colors.base0D};
      }
      #tray {
        background-color:         #${settings.colors.base0D};
      }
      #idle_inhibitor {
        background-color:         #${settings.colors.base07};
      }
      #idle_inhibitor.activated {
        background-color:         #${settings.colors.base02};
        color:                    #${settings.colors.base07};
      }
      #clock {
        background-color:         #${settings.colors.base0A};
      }
      #custom-vpn {
        background-color:         #${settings.colors.base0F};
      }
    '';
  };
}

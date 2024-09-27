{ pkgs, settings }:
{
  programs.waybar = {
    enable = true;
    systemd.enable = false;
    settings = { 
      mainBar = {
        layer = "top";
        position = "top";
        output = [ "eDP-1" ];
        height = 28;
        modules-left = [ "hyprland/workspaces" "mpris" ];
        modules-center = [ ];
        modules-right = [ "custom/bat" "custom/vpn" "pulseaudio" "tray" "idle_inhibitor" "clock" ];
        "hyprland/workspaces" = {
          format = "{icon}";
          on-click = "activate";
          persistent-workspaces = (builtins.listToAttrs 
          (builtins.map (x: { name = "${x}"; value = [];})
          [ "1" "2" "3" "4" "5" "6" "7" "8" "9" "10" ]));
          format-icons = {
            "1" = "I"; "2" = "II"; "3" = "III"; "4" = "IV"; "5" = "V"; "6" = "VI"; "7" = "VII"; "8" = "VIII"; "9" = "IX"; "10" = "X"; 
          };
        };
        "mpris" = {
          format = "<b>{status_icon}</b> {artist} <b>—</b> {title}";
          on-right-click = "shift";
          max-length = 90;
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
          format = "{volume} {format_source}";
          format-muted = "0 {format_source}";
          format-source = "{volume}";
          format-source-muted = "0";
          on-click = "${pkgs.pavucontrol}/bin/pavucontrol";
        };
        "custom/vpn" = let 
          vpn = pkgs.writeShellScriptBin "vpn.sh" ''
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
              echo "VPN A"
            else
              echo "VPN D"
            fi
          '';
        in { 
          exec = "${vpn}/bin/vpn.sh";
          on-click = "${vpn}/bin/vpn.sh -t";
          interval = 1;
        };
        "custom/bat" = let 
          bat = pkgs.writeShellScriptBin "bat.sh" ''
            BAT0=$(cat /sys/class/power_supply/BAT0/capacity)
            BAT1=$(cat /sys/class/power_supply/BAT1/capacity)
            echo $BAT0 $BAT1
          '';
        in {
          exec = "${bat}/bin/bat.sh";
          interval = 5;
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
      #mpris,#pulseaudio,#tray,#idle_inhibitor,#clock,#custom-vpn,#custom-bat {
        padding: 0px 5px;
        margin: 0px 5px;
        color: #${settings.colors.base00};
      }
      #mpris {
        background-color:         #${settings.colors.base0D};
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
      #custom-vpn,#custom-bat {
        background-color:         #${settings.colors.base0F};
      }
      #workspaces button {
        background-color:         #${settings.colors.base00};
        margin: 0px;
        padding: 0px;
      }
      #workspaces button.empty {
        color:                    #${settings.colors.base02};
      }
      #workspaces button.active {
        color:                    #${settings.colors.base0A};
        border-bottom:  2px solid #${settings.colors.base0A};
      }
      #workspaces button:hover {
        background-color:         #${settings.colors.base01};
      }
    '';
  };
}

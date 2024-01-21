{ colors, pkgs }:
let
  screenshot = pkgs.writeShellScriptBin "screenshot.sh" ''
FILE=$HOME/.local/tmp/screenshots/$(date +%d%m%y_%H%M%S).png
if [ "$1" == "-p" ]; then
  AREA="$(${pkgs.slurp}/bin/slurp)"
else
  AREA="0,0 1920x1080"
fi
if ${pkgs.grim}/bin/grim -g "$AREA" "$FILE"; then
  cat $FILE | ${pkgs.wl-clipboard}/bin/wl-copy --type image/png
fi
  '';
in
{
  enable = true;
  config = {
    assigns = {
      "6: Steam" = [{class = "steam";}];
      "10: (null)" = [];
    };
    bindkeysToCode = true;
    bars = [];
    colors = {
      background = "#${colors.black}";
      focused = {
        border = "#${colors.brightBlue}";
        background = "#${colors.black}";
        text = "#${colors.brightGray}";
        indicator = "#${colors.aqua}";
        childBorder = "#${colors.blue}";
      };
      focusedInactive = {
        border = "#${colors.gray}";
        background = "#${colors.brightBlack}";
        text = "#${colors.black}";
        indicator = "#${colors.brightBlack}";
        childBorder = "#${colors.black}";
      };
       unfocused = {
        border = "#${colors.brightBlue}";
        background = "#${colors.gray}";
        text = "#${colors.black}";
        indicator = "#${colors.black}";
        childBorder = "#${colors.gray}";
      };   
      urgent = {
        border = "#${colors.black}";
        background = "#${colors.red}";
        text = "#${colors.brightGray}";
        indicator = "#${colors.red}";
        childBorder = "#${colors.red}";
      };
      placeholder = {
        border = "#${colors.ultrablack}";
        background = "#${colors.black}";
        text = "#${colors.brightGray}";
        indicator = "#${colors.ultrablack}";
        childBorder = "#${colors.black}";
      };
    };
    floating = {
      border = 2;
      titlebar = true;
      modifier = "Mod4";
      criteria = [ {class = ".gamescope-wrapped";} ];
    };
    window = {
      border = 1;
      titlebar = false;
    };
    input."*" = {
      xkb_layout = "us(dvorak),ru";
      xkb_options = "grp:win_space_toggle";
      accel_profile = "flat";
      pointer_accel = "-0.5";
    };
    output.HDMI-A-1 = {
      bg = "/etc/nixos/assets/wallpaper.png fill";
      mode = "1920x1080@71.910Hz";
      adaptive_sync = "on";
    };
    keybindings = let
      mod = "Mod4";
      tmux_term = "${pkgs.foot}/bin/footclient -e ${pkgs.tmux}/bin/tmux a";
      term = "${pkgs.foot}/bin/foot";
      menu = ''${pkgs.bemenu}/bin/bemenu-run --fn 'JetBrainsMono Nerd Font:size=15'\
        --nb '#${colors.black}' --fb '#${colors.black}' --nf '#${colors.brightGray}'\
        --sb '#${colors.aqua}' --sf '#${colors.black}' --hf '#${colors.brightGray}'\
        --tf '#${colors.brightGray}' --tb '#${colors.yellow}' -b'';
      second_menu = "${pkgs.rofi-wayland}/bin/rofi -show drun -show-icons";
      lock = "${pkgs.swaylock-effects}/bin/swaylock";
    in {
      "${mod}+F2" = "exec ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%-";
      "${mod}+F3" = "exec ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%+";
      "${mod}+F4" = "exec ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
      "${mod}+F5" = "exec ${pkgs.pulseaudio}/bin/pactl set-source-mute @DEFAULT_SOURCE@ toggle";
      "${mod}+F6" = "exec ${pkgs.playerctl}/bin/playerctl previous";
      "${mod}+F7" = "exec ${pkgs.playerctl}/bin/playerctl play-pause";
      "${mod}+F8" = "exec ${pkgs.playerctl}/bin/playerctl next";
      "Menu" = "exec ${pkgs.pulseaudio}/bin/pactl set-source-mute @DEFAULT_SOURCE@ toggle";

      "Pause" =              "exec ${lock}";
      "${mod}+Shift+Pause" = "exec ${lock} & systemctl suspend";

      "${mod}+Return" =       "exec ${tmux_term}";
      "${mod}+Shift+Return" = "exec ${term}";
      "${mod}+Shift+d" =  "exec ${second_menu}";
      "${mod}+d" =        "exec ${menu}";
      "${mod}+Shift+q" = "kill";
      "${mod}+Shift+c" = "reload";
      "${mod}+Shift+e" = "exec swaymsg exit";

      "${mod}+Left"  = "focus left";
      "${mod}+Down"  = "focus down";
      "${mod}+Up"    = "focus up";
      "${mod}+Right" = "focus right";
      
      "${mod}+Shift+Left"  = "move left";
      "${mod}+Shift+Down"  = "move down";
      "${mod}+Shift+Up"    = "move up";
      "${mod}+Shift+Right" = "move right";
      "${mod}+1" = "workspace number 1";
      "${mod}+2" = "workspace number 2";
      "${mod}+3" = "workspace number 3";
      "${mod}+4" = "workspace number 4";                             
      "${mod}+5" = "workspace number 5";                         
      "${mod}+6" = "workspace number 6";                         
      "${mod}+7" = "workspace number 7";
      "${mod}+8" = "workspace number 8";
      "${mod}+9" = "workspace number 9";
      "${mod}+0" = "workspace number 10";
      "${mod}+Shift+1" = "move container to workspace number 1";
      "${mod}+Shift+2" = "move container to workspace number 2";
      "${mod}+Shift+3" = "move container to workspace number 3";
      "${mod}+Shift+4" = "move container to workspace number 4";
      "${mod}+Shift+5" = "move container to workspace number 5";
      "${mod}+Shift+6" = "move container to workspace number 6";
      "${mod}+Shift+7" = "move container to workspace number 7";
      "${mod}+Shift+8" = "move container to workspace number 8";
      "${mod}+Shift+9" = "move container to workspace number 9";
      "${mod}+Shift+0" = "move container to workspace number 10";

      "${mod}+b" = "splith";
      "${mod}+v" = "splitv";
      "${mod}+s" = "layout stacking";
      "${mod}+w" = "layout tabbed";
      "${mod}+e" = "layout toggle split";
      "${mod}+f" = "fullscreen";
      "${mod}+Shift+x" = "floating toggle";
      "${mod}+x" = "focus mode_toggle";
      "${mod}+a" = "focus parent";
      "${mod}+Shift+minus" = "move scratchpad";
      "${mod}+minus" = "scratchpad show";

      "${mod}+r" = "mode resize";

      "Print" = "exec ${screenshot}/bin/screenshot.sh";
      "${mod}+grave" = "exec ${screenshot}/bin/screenshot.sh -p";

    };
    modes = {
      resize = {
        Down =  "resize grown height 10px";
        Left =  "resize shrink width 10 px";
        Right = "resize grow width 10 px";
        Up =    "resize shrink height 10 px";
        Escape = "mode default";
        Return = "mode default";
      };
    };
    startup = [ {command = "${pkgs.swaykbdd}/bin/swaykbdd";} ];
  };
}

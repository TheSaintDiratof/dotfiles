{ pkgs, settings }:
let
  screenshot = pkgs.writeShellScriptBin "screenshot.sh" ''
if [ "$1" == "-p" ]; then
  FLAG="-g \"$(${pkgs.slurp}/bin/slurp)\""
else
  OUTPUT="-o $(${pkgs.sway}/bin/swaymsg -t get_outputs --raw | ${pkgs.jq}/bin/jq '. | map(select(.focused == true)) | .[0].name' -r)"
fi
FILE=$HOME/.local/tmp/screenshots/$(date +%d%m%y_%H%M%S).png
if echo $FLAG $FILE | xargs ${pkgs.grim}/bin/grim $OUTPUT; then
  cat $FILE | ${pkgs.wl-clipboard}/bin/wl-copy --type image/png
fi
  '';
in
{ 
  wayland.windowManager.sway =  {
    enable = true;
    config = {
      assigns = {
        "6" = [{class = "steam";}];
      };
      bindkeysToCode = true;
      bars = [];
      fonts ={
        names = [ "FiraCode Nerd Font" "InconsolataGo Nerd Font Mono" ];
        size = 10.0;
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
        xkb_layout = "us(colemak),ru";
        xkb_options = "grp:caps_toggle,grp_led:caps";
        accel_profile = "flat";
        pointer_accel = "-0.5";
      };
      output.HDMI-A-1 = {
        #bg = "${../../assets/wallpaper.png} fill";
        bg = "${settings.wallpaper} tile";
        mode = "1920x1080@71.910Hz";
        adaptive_sync = "on";
        pos = "760 178";
        scale = "1.2";
      };
      output.DVI-D-1 = {
        bg = "${settings.wallpaper} tile";
        mode = "1440x900@74.984Hz";
        transform = "270";
        pos = "0 0";
        scale = "1.2";
      };
      workspaceOutputAssign =
        (builtins.map (x: 
          { workspace = "${x}"; 
            output = "HDMI-A-1";
          }) 
          [ "0" "1" "2" "3" "4" "5" "6" "7" "8" "9" "10"]
        ) ++
        (builtins.map (x: 
          { workspace = "0${x}"; 
            output = "DVI-D-1";
          }) 
          [ "0" "1" "2" "3" "4" "5" "6" "7" "8" "9" "10"]
        );
      keybindings = let
        mod = "Mod4";
        tmux_term = "${settings.terminal} -e ${pkgs.tmux}/bin/tmux a";
        term = "${settings.terminal}";
        menu = ''${pkgs.bemenu}/bin/bemenu-run --fn 'Terminus Bold 14'\
          --nb '#${settings.colors.black}' --fb '#${settings.colors.black}' --nf '#${settings.colors.brightGray}'\
          --sb '#${settings.colors.aqua}' --sf '#${settings.colors.black}' --hf '#${settings.colors.brightGray}'\
          --tf '#${settings.colors.brightGray}' --tb '#${settings.colors.yellow}' -b'';
        second_menu = "${pkgs.rofi-wayland}/bin/rofi -show drun -show-icons";
        lock = "${pkgs.swaylock-effects}/bin/swaylock";
      in {
        "${mod}+F2" = "exec ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%-";
        "${mod}+F3" = "exec ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%+";
        "${mod}+F4" = "exec ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        "${mod}+F5" = "exec ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_SOURCE@ toggle";
        "Menu" = "exec ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_SOURCE@ toggle";
        "${mod}+F6" = "exec ${pkgs.playerctl}/bin/playerctl previous";
        "${mod}+F7" = "exec ${pkgs.playerctl}/bin/playerctl play-pause";
        "${mod}+F8" = "exec ${pkgs.playerctl}/bin/playerctl next";

        "${mod}+L" = "exec ${lock}";

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

        "${mod}+Control+1" = "workspace number 01";
        "${mod}+Control+2" = "workspace number 02";
        "${mod}+Control+3" = "workspace number 03";
        "${mod}+Control+4" = "workspace number 04";
        "${mod}+Control+5" = "workspace number 05";
        "${mod}+Control+6" = "workspace number 06";
        "${mod}+Control+7" = "workspace number 07";
        "${mod}+Control+8" = "workspace number 08";
        "${mod}+Control+9" = "workspace number 09";
        "${mod}+Control+0" = "workspace number 010";
        "${mod}+Control+Shift+1" = "move container to workspace number 01";
        "${mod}+Control+Shift+2" = "move container to workspace number 02";
        "${mod}+Control+Shift+3" = "move container to workspace number 03";
        "${mod}+Control+Shift+4" = "move container to workspace number 04";
        "${mod}+Control+Shift+5" = "move container to workspace number 05";
        "${mod}+Control+Shift+6" = "move container to workspace number 06";
        "${mod}+Control+Shift+7" = "move container to workspace number 07";
        "${mod}+Control+Shift+8" = "move container to workspace number 08";
        "${mod}+Control+Shift+9" = "move container to workspace number 09";
        "${mod}+Control+Shift+0" = "move container to workspace number 010";

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

        "${mod}+Escape" = "exec ${screenshot}/bin/screenshot.sh";
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
      startup = [ 
        {command = "${pkgs.swaykbdd}/bin/swaykbdd";} 
        {command = "${pkgs.waybar}/bin/waybar";}
      ];
      colors = {
        background = "#${settings.colors.black}";
        focused = {
          border = "#${settings.colors.brightBlue}";
          background = "#${settings.colors.black}";
          text = "#${settings.colors.brightGray}";
          indicator = "#${settings.colors.aqua}";
          childBorder = "#${settings.colors.blue}";
        };
        focusedInactive = {
          border = "#${settings.colors.gray}";
          background = "#${settings.colors.brightBlack}";
          text = "#${settings.colors.black}";
          indicator = "#${settings.colors.brightBlack}";
          childBorder = "#${settings.colors.black}";
        };
         unfocused = {
          border = "#${settings.colors.brightBlue}";
          background = "#${settings.colors.gray}";
          text = "#${settings.colors.black}";
          indicator = "#${settings.colors.black}";
          childBorder = "#${settings.colors.gray}";
        };   
        urgent = {
          border = "#${settings.colors.black}";
          background = "#${settings.colors.red}";
          text = "#${settings.colors.brightGray}";
          indicator = "#${settings.colors.red}";
          childBorder = "#${settings.colors.red}";
        };
        placeholder = {
          border = "#${settings.colors.ultrablack}";
          background = "#${settings.colors.black}";
          text = "#${settings.colors.brightGray}";
          indicator = "#${settings.colors.ultrablack}";
          childBorder = "#${settings.colors.black}";
        };
      };
    };
  };
}

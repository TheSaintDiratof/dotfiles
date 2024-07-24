{ pkgs, settings }:
{
  enable = true;
  systemd.enable = true;
  settings = {
    monitor = "HDMI-A-1,1920x1080@60,0x0";
    general = {
      gaps_in = 5;
      gaps_out = 5;
      gaps_workspaces = 0;

      border_size = 1;
      no_border_on_floating = false;

      layout = "dwindle";
      no_focus_fallback = false;
      allow_tearing = false;
    };
    decoration = {
      shadow_render_power = 4;
      rounding = 0;
    };
    input = {
      kb_model = "";
      kb_layout = "us, ru";
      kb_variant = "colemak, ";
      kb_options = "grp:win_space_toggle";
      repeat_rate = 25;
      repeat_delay = 600;
      sensitivity = 0.0;
      accel_profile = "flat";
      follow_mouse = 1;
      mouse_refocus = true;
      float_switch_override_focus = 1;
    };
    gestures = {
      workspace_swipe = true;
      workspace_swipe_fingers = 3;
      workspace_swipe_distance = 300;
      workspace_swipe_invert = true;
      workspace_swipe_min_speed_to_force = 30;
    };
    exec-once = [ 
      "${pkgs.hyprland-per-window-layout}/bin/hyprland-per-window-layout" 
      "${pkgs.waybar}/bin/waybar"
    ];
    misc = {
      disable_hyprland_logo = true;
      vrr = 1;
    };
    xwayland.force_zero_scaling = true;
    "$mod" = "SUPER";
    bind = let
      screenshot = pkgs.writeShellScriptBin "screenshot.sh" ''
        if [ "$1" == "-p" ]; then
          FLAG="-g \"$(${pkgs.slurp}/bin/slurp)\""
        fi
        FILE=$HOME/.local/tmp/screenshots/$(date +%d%m%y_%H%M%S).png
        if echo $FLAG $FILE | xargs ${pkgs.grim}/bin/grim; then
          cat $FILE | ${pkgs.wl-clipboard}/bin/wl-copy --type image/png
        fi
      '';
      tmux_term = "${settings.terminal} -e ${pkgs.tmux}/bin/tmux a";
      term = "${settings.terminal}";
      menu = pkgs.writeShellScriptBin "dmenu.sh " ''
        ${pkgs.bemenu}/bin/bemenu-run --fn 'Terminus Bold 12' \
        --nb '#${settings.colors.black}' --fb '#${settings.colors.black}' \
        --nf '#${settings.colors.brightGray}' --sb '#${settings.colors.aqua}' \
        --sf '#${settings.colors.black}' --hf '#${settings.colors.brightGray}' \
        --tf '#${settings.colors.brightGray}' --tb '#${settings.colors.yellow}' -b
      '';
      second_menu = "${pkgs.rofi-wayland}/bin/rofi -show drun -show-icons";
      lock = "${pkgs.hyprlock}/bin/hyprlock";

    in [
      "$mod, F1, exec, ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      "$mod, F2, exec, ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%-"
      "$mod, F3, exec, ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%+"
      "$mod, F4, exec, ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
      "$mod, F6, exec, ${pkgs.playerctl}/bin/playerctl previous"
      "$mod, F7, exec, ${pkgs.playerctl}/bin/playerctl play-pause"
      "$mod, F8, exec, ${pkgs.playerctl}/bin/playerctl next"
      ",Menu, exec, ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"

      "$mod, L, exec, ${lock}"

      "$mod, RETURN, exec, ${tmux_term}"
      "$mod SHIFT, RETURN, exec, ${term}"
      "$mod SHIFT, D, exec, ${second_menu}"
      "$mod, D, exec, ${menu}"

      "$mod SHIFT, Q, killactive"
      #"$mod SHIFT, C, reload"
      "$mod SHIFT, E, exec, hyprctl dispatch exit 1"

      "$mod, left, movefocus, l"
      "$mod, down, movefocus, d"
      "$mod, up, movefocus, u"
      "$mod, right, movefocus, r"

      "$mod, 1, workspace, 1"
      "$mod, 2, workspace, 2"
      "$mod, 3, workspace, 3"
      "$mod, 4, workspace, 4"                             
      "$mod, 5, workspace, 5"                         
      "$mod, 6, workspace, 6"                         
      "$mod, 7, workspace, 7"
      "$mod, 8, workspace, 8"
      "$mod, 9, workspace, 9"
      "$mod, 0, workspace, 10"
      "$mod SHIFT, 1, movetoworkspace, 1"
      "$mod SHIFT, 2, movetoworkspace, 2"
      "$mod SHIFT, 3, movetoworkspace, 3"
      "$mod SHIFT, 4, movetoworkspace, 4"
      "$mod SHIFT, 5, movetoworkspace, 5"
      "$mod SHIFT, 6, movetoworkspace, 6"
      "$mod SHIFT, 7, movetoworkspace, 7"
      "$mod SHIFT, 8, movetoworkspace, 8"
      "$mod SHIFT, 9, movetoworkspace, 9"
      "$mod SHIFT, 0, movetoworkspace, 10"

      "$mod, g, fullscreen"
      "$mod SHIFT, x, togglefloating"
      #"$mod, x, focus mode_toggle"

      "$mod SHIFT, S, movetoworkspace, special"
      "$mod, S, togglespecialworkspace"

      "$mod, r, submap,resize"

      "$mod, escape, exec, ${screenshot}/bin/screenshot.sh"
      "$mod, grave, exec, ${screenshot}/bin/screenshot.sh -p"
    ];
    bindm = [
      "$mod, mouse:272, movewindow"
      "$mod, mouse:273, resizewindow"
    ];
  };
  extraConfig = ''
    submap = resize
      binde = , right, resizeactive, 10 0
      binde = , left, resizeactive, -10 0
      binde = , up, resizeactive, 0 -10
      binde = , down, resizeactive, 0 10
      binde = , escape, submap, reset
    submap = reset
    general:col.active_border = "0xFF${settings.colors.yellow}"
    general:col.inactive_border = "0xFF${settings.colors.gray}"
    general:col.nogroup_border = "0xFF${settings.colors.brightPurple}"
    general:col.nogroup_border_active = "0xFF${settings.colors.purple}"
    #decoration:col.shadow = "0xEE${settings.colors.black}"
    #decoration:col.shadow_inactive = "0xEE${settings.colors.brightBlack}"
  '';
}

{ pkgs, settings }:
{
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;
    settings = {
      env = [
        "QT_QPA_PLATFORMTHEME,qt5ct "
      ];
      monitor = "eDP-1,1920x1080@60.00,0x0,1.5";
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
      windowrulev2 = [
        #"immediate, class:^(cs2)$"
        "float, class:(org.telegram.desktop), title:(Media viewer)"
        "size 1908 1039, class:(org.telegram.desktop), title:(Media viewer)"
        "move 6 36, class:(org.telegram.desktop), title:(Media viewer)"
        "workspace 6, class:(steam), title:(Steam)"
        "workspace 7, class:(cs2)"
        "float, class:(org.qbittorrent.qBittorrent), title:(^((?!qBittorrent v4\.6\.4).)*$)"
      ];
      decoration = {
        shadow_render_power = 4;
        rounding = 0;
      };
      device = [
        { name = "tpps/2-ibm-trackpoint";
          sensitivity = 0.3;
        }
        { name = "synaptics-tm3276-022";
          sensitivity = 0.0;
        }
      ];
      input = {
        kb_model = "";
        kb_layout = "us, ru";
        kb_variant = "colemak, ";
        kb_options = "grp:win_space_toggle";
        repeat_rate = 25;
        repeat_delay = 600;
        sensitivity = -0.5;

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
        "${pkgs.hypridle}/bin/hypridle"
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
          FILE=$HOME/.local/tmp/screenshots/$(date +%y%m%d_%H%M%S).png
          if echo $FLAG $FILE | xargs ${pkgs.grim}/bin/grim; then
            cat $FILE | ${pkgs.wl-clipboard}/bin/wl-copy --type image/png
          fi
        '';
        tmux_term = "${settings.terminal} -e ${pkgs.tmux}/bin/tmux a";
        term = "${settings.terminal}";
        menu = pkgs.writeShellScriptBin "bemenu.sh" ''
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
        ",print, exec, ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ",XF86MonBrightnessDown, exec, ${pkgs.brightnessctl}/bin/brightnessctl set 1%-"
        ",XF86MonBrightnessUp, exec, ${pkgs.brightnessctl}/bin/brightnessctl set 1%+"

        "$mod, L, exec, ${lock}"

        "$mod, RETURN, exec, ${tmux_term}"
        "$mod SHIFT, RETURN, exec, ${term}"
        "$mod SHIFT, D, exec, ${second_menu}"
        "$mod, D, exec, ${menu}/bin/bemenu.sh"

        "$mod SHIFT, Q, killactive"
        "$mod SHIFT, C, exec, hyprctl reload"
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
        "$mod SHIFT, g, fakefullscreen"
        "$mod SHIFT, x, togglefloating"
        "$mod, p, pseudo,"
        "$mod, f, togglesplit,"
        "$mod, t, togglegroup"

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
      general:col.active_border = "0xFF${settings.colors.base0D}"
      general:col.inactive_border = "0xFF${settings.colors.base03}"
      group:col.border_inactive = "0xFF${settings.colors.base03}";
      group:col.border_active = "0xFF${settings.colors.base0D}";
      group:col.border_locked_active = "0xFF${settings.colors.base0C}";
      #groupbar:col.active = "0xFF${settings.colors.base0D}";
      #groupbar:col.inactive = "0xFF${settings.colors.base03}";
      #decoration:col.shadow = "0xEE${settings.colors.base00}"
    '';
  };
}

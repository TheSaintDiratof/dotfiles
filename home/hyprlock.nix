{ settings }:
{
  enable = true;
  settings = {
    general = {
      hide_cursor = true;
      ignore_empty_input = true;
    };
    background = [ { 
      monitor = ""; 
      path = "${settings.wallpaper}"; 
    } ];
    label = [ 
      { # Clock
        monitor = "";
        text = "cmd[update:1000] date +'%H:%M:%S'";
        shadow_passes = 1;
        shadow_boost = 0.5;
        color = "0xFF${settings.colors.brightGray}";
        font_size = 65;
        font_family = "${settings.fonts.lock}";

        position = "600, -430";
        halign = "center";
        valign = "center";
      } 
      { # Date
        monitor = "";
        text = "cmd[update:1000] date +'%a, %d/%m/%y'";
        shadow_passes = 1;
        shadow_boost = 0.5;
        color = "0xFF${settings.colors.brightGray}";
        font_size = 30;
        font_family = "${settings.fonts.lock}";

        position = "600, -400";
        halign = "center";
        valign = "center";
      }
      { # Layout
        monitor = "";
        text = "$LAYOUT";
        shadow_passes = 1;
        shadow_boost = 0.5;
        color = "0xFF${settings.colors.brightGray}";
        font_size = 14;
        font_family = "${settings.fonts.lock}";

        position = "600, -400";
        halign = "center";
        valign = "center";
      }
    ];
    input-field = {
      size = "400, 80";
      position = "0, 000";
      monitor = "";
      outline_thickness = 5;
      dots_size = 0.6; # Scale of input-field height, 0.2 - 0.8
      dots_spacing = 0.15; # Scale of dots' absolute size, 0.0 - 1.0
      dots_center = false;
      dots_rounding = -1; # -1 default circle, -2 follow input-field rounding
      outer_color = "0xCC${settings.colors.brightGray}";
      inner_color = "0xCC${settings.colors.black}";
      font_color = "0xCC${settings.colors.brightGray}";
      check_color = "0xCC${settings.colors.yellow}";
      fail_color = "0xCC${settings.colors.red}"; # if authentication failed, changes outer_color and fail message color
      fade_on_empty = true;
      fade_timeout = 1000; # Milliseconds before fade_on_empty is triggered.
      placeholder_text = "<i>Input Password...</i>"; # Text rendered in the input box when it's empty.
      hide_input = false;

      fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>"; # can be set to empty
      #fail_timeout = 2000; # milliseconds before fail_text and fail_color disappears
      fail_transition = 300; # transition time in ms between normal outer_color and fail_color
      capslock_color = -1;
      numlock_color = -1;
      bothlock_color = -1; # when both locks are active. -1 means don't change outer color (same for above)
      invert_numlock = false; # change color if numlock is off
      swap_font_color = false; # see below

      rounding = -1; # -1 means complete rounding (circle/oval)
      halign = "center";
      valign = "center";
    };
  };
}

{ pkgs }:
{
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        #after_sleep_cmd = "hyprctl dispatch dpms on";
        ignore_dbus_inhibit = false;
        lock_cmd = "pidof hyprlock || hyprlock";
      };

      listener = [
        {
          timeout = 600;
          on-timeout = "loginctl lock-session";
        }
        #{
          #timeout = 900;
          #on-timeout = "hyprctl dispatch dpms off";
          #on-resume = "hyprctl dispatch dpms on";
        #}
      ];
    };
  };
}

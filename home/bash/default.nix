{ ... }:
{
  programs.bash = {
    enable = true;
    sessionVariables = {
      EDITOR = "nvim";
      PS1="\\e[1m\\u\\e[0m:\\$PWD >";
    };
    shellAliases = {
      termbin = "nc termbin.com 9999";
      cal = "cal -m";
      cputemp = "cat /sys/devices/platform/coretemp.0/hwmon/hwmon1/temp1_input | cut -b -2";
      bat = "cat /sys/class/power_supply/BAT{0,1}/capacity";
      dict = "sdcv -2 ~/.local/dict/useful";
      phrasebook = "sdcv -2 ~/.local/dict/phrasebook";
    };
    profileExtra = ''
      bind '"\C-d": possible-completions'
      bind '"\e[5~":history-search-backward'
      bind '"\e[6~":history-search-forward'
    '';
  };
}

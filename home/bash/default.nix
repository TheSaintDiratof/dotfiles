{ ... }:
{
  programs.bash = {
    enable = true;
    sessionVariables = {
      EDITOR = "nvim";
      PS1="\\[\\e[1m\\u\\e[0m\\]:\\$PWD >";
    };
    shellAliases = {
      termbin = "nc termbin.com 9999";
      cal = "cal -m";
      cputemp = "cat /sys/devices/platform/coretemp.0/hwmon/hwmon?/temp1_input | cut -b -2";
      bat = "cat /sys/class/power_supply/BAT*/capacity";
      dict = "sdcv -2 ~/.local/dict/useful";
      phrasebook = "sdcv -2 ~/.local/dict/phrasebook";
    };
    profileExtra = ''
      bind '"\C-d": possible-completions'
      bind '"\e[5~":history-search-backward'
      bind '"\e[6~":history-search-forward'
      tabletki() { # Эту хуйню уже постили в тгк @diratof (см. закреп #15)
        local FILE=$HOME/.tabletki
        local DATE=$(date +%d%m%y)
        if [ -e $FILE ]; then
          grep $DATE $FILE &> /dev/null && echo Уже выпил || echo Ещё не выпил && echo $DATE >> $FILE
        else
          echo $DATE >> $FILE
          echo Ещё не выпил
        fi
      }
    '';
  };
}

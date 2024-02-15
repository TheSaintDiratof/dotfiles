{ pkgs }:
{
  enable = true;
  clock24 = false;
  historyLimit = 10000;
  escapeTime = 10;
  mouse = true;
  newSession = true;
  prefix = "C-q";
  terminal = "tmux-256color";
  baseIndex = 1;
  shell = ''${pkgs.tcsh}/bin/tcsh'';
  extraConfig = ''bind e split -hc "#{pane_current_path}"
bind s split -c "#{pane_current_path}"
bind q kill-pane
bind -n M-1 selectw -t:1
bind -n M-2 selectw -t:2
bind -n M-3 selectw -t:3
bind -n M-4 selectw -t:4
bind -n M-5 selectw -t:5
bind -n M-6 selectw -t:6
bind -n M-7 selectw -t:7
bind -n M-8 selectw -t:8
bind -n M-9 selectw -t:9
bind -n M-0 selectw -t:10
bind -n S-Pageup copy-mode -u
bind h set-option status
bind t choose-tree -Zs
bind w selectp -t :.+
bind -n M-f copy-mode \; send-key ^S
bind p display-popup
bind S-right swap-pane -D
bind S-left swap-pane -U
set-option -g focus-events on

setw -g pane-base-index 1
set -g renumber-windows on
set -g pane-active-border-style fg=terminal,bold
set -g pane-border-style fg=colour8,dim,overline

setw -g window-status-format "#[bg=white,fg=black] #I #[bg=white,fg=black]#W "
setw -g window-status-current-format "#[bg=grey,fg=black,bold] #I #[bg=grey,fg=black,nobold]#W "
set-window-option -g mode-style bg=colour8,fg=white
set-window-option -g pane-border-format "#[align=left]#[fg=dim]{#{s|$HOME|~|:pane_current_path}}"

set -g status-justify left
set -g status-style bg=default
set -g status-fg colour7
set -g status-interval 1
set -g status-right-length 100
set -g status-right '#[bg=colour8,fg=terminal]#{?client_prefix, prefix ,}'
set -g set-titles on
set -g set-titles-string "#W"'';
}

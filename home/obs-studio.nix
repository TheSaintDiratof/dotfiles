{ pkgs }:
{
  enable = true;
  plugins = with pkgs.obs-studio-plugins; [
    wlrobs
    obs-vkcapture
    obs-pipewire-audio-capture
  ];
}

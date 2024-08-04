{ pkgs, ... }:
{
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    alsa.support32Bit = true;
    jack.enable = true;
    configPackages = [
      (pkgs.writeTextDir "share/pipewire/pipewire.conf.d/99-rnnoise.conf" ''
        context.modules = [
        { name = libpipewire-module-filter-chain
          args = {
            node.description = "Noise Canceling source"
            media.name       = "Noise Canceling source"
            filter.graph = {
              nodes = [
                {
                  type   = ladspa
                  name   = rnnoise
                  plugin = ${pkgs.rnnoise-plugin}/lib/ladspa/librnnoise_ladspa.so
                  label  = noise_suppressor_stereo
                  control = {
                      "VAD Threshold (%)" = 95.0
                  }
                }
              ]
            }
            audio.position" = [ "FL" "FR" ]
            capture.props" = {
              node.name = effect_input.rnnoise
              node.passive = true
            }
            playback.props = {
              node.name = rnnoise_source
              media.class = Audio/Source
            }
          }
        }
        ]
      '')
    ];
  };
}

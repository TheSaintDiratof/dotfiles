{ pkgs, inputs, ch341prog, ... }:
let
  settings = import ./settings.nix { inherit pkgs; };
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./wireguard.nix
      ./xray.nix
      ./pipewire.nix
      ./dns.nix
    ];
    # Use the systemd-boot EFI boot loader.
  boot = { 
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      efi.efiSysMountPoint = "/boot";
    };
    kernelPackages = pkgs.linuxKernel.packages.linux_rt_5_15; 
    supportedFilesystems = [ "zfs" ];
    zfs.extraPools = [ "pool0" ];
    binfmt.emulatedSystems = [ "aarch64-linux" "armv7l-linux" ];
  };

  networking = {
    hostName = "4eJIoBe4HoCTb"; # Define your hostname.
    hostId = "b97281ff";
    dhcpcd.wait = "background";
    firewall = {
      enable = true;
      allowedTCPPorts = [ 7777 ];
      allowedUDPPorts = [ 7777 ];
    };
    #nftables.enable = true;
  };

  time.timeZone = "Asia/Yekaterinburg";


  i18n = { 
    defaultLocale = "en_US.UTF-8";
    supportedLocales = [ "C.UTF-8/UTF-8" "en_US.UTF-8/UTF-8" "ru_RU.UTF-8/UTF-8" "en_GB.UTF-8/UTF-8" ];
  };
  console = {
    keyMap = "colemak";
    font = "drdos8x16";
  };
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.diratof = {
    isNormalUser = true;
    extraGroups = [ "dialout" "wheel" "audio" "video" "input" "pipewire" "tty" ];     
    packages = with pkgs; [
      tmux
      bc
      cmus
      #xonotic
      #qemu
      # desktop
      pavucontrol
      qbittorrent
      libreoffice-fresh
      mc
      yt-dlp android-tools
      sdcv

      yacreader nomacs
      swayimg feh krita gimp3-with-plugins
      gamescope
      zathura
      mpv
      calibre
      musescore

      #telegram-desktop
      materialgram
      wl-clipboard
      #(ch341prog.packages."x86_64-linux".default)
      (pkgs.callPackage ./packages/awesfx.nix {})
    ] ++ [ inputs.agenix.packages.${pkgs.system}.default ];
    #shell = "${pkgs.bash}/bin/bash";
  };

  environment.systemPackages = with pkgs; [
    neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    htop
    unzip rar
    git
  ];
  security.rtkit.enable = true;
  services = {
    zerotierone = {
      enable = true;
      joinNetworks = [ 
        #"88503383902e5133" 
        "db64858fed5d7948" 
      ];
    };
    dbus.enable = true;
    libinput = {
      enable = true;
      mouse.accelSpeed = "-1";
    };
    xserver = {
      enable = true;
      xkb = {
        layout = "us,ru";
        variant = "colemak,";
        options = "grp:win_space_toggle";
      };
      videoDrivers = settings.videoDrivers;
      displayManager.gdm = {
          enable = true;
          wayland = true;
      };
    };
    printing = {
      enable = true;
      drivers = [ pkgs.hplipWithPlugin ];
    };
    atftpd.enable = true; #todelete; oneshot action
    udev.extraRules = ''
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="3748", \
        MODE:="0666", \
        SYMLINK+="stlinkv2_%n"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1a86", ATTRS{idProduct}=="5512", \
        MODE:="0666"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1209", ATTRS{idProduct}=="abd1", \
        MODE:="0666"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="18d1", ATTRS{idProduct}=="d00d", \
        MODE:="0666"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="18d1", ATTRS{idProduct}=="4ee7", \
        MODE:="0666"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="18d1", ATTRS{idProduct}=="4ee4", \
        MODE:="0666"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="2b0e", ATTRS{idProduct}=="171b", \
        MODE:="0666"
    '';
    chrony = {
      enable = true;
      servers = [ "0.ru.pool.ntp.org" "1.ru.pool.ntp.org" "2.ru.pool.ntp.org" "3.ru.pool.ntp.org" ];
    };
  };
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-wlr pkgs.xdg-desktop-portal-gtk ];
  }; 
  programs = {
    hyprland = {
      enable = false;
      xwayland.enable = true;
    };
    sway = {
      enable = true;
      wrapperFeatures.gtk = true;
      xwayland.enable = true;
    };
    steam.enable = true;
  };
  security = {
    polkit.extraConfig = ''
      polkit.addRule(function(action, subject) {
        if (subject.isInGroup("users") && (action.id == "org.freedesktop.systemd1.manage-units"))
        {
          return polkit.Result.YES;
        }
      })
    '';
    doas.enable = false;
    sudo.enable = false;
  };
  hardware = {
    amdgpu.amdvlk.enable = true;
    amdgpu.amdvlk.support32Bit.enable = true;
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    bluetooth.enable = true;
    #pulseaudio.enable = false;
  };
  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      corefonts
      terminus_font
      comfortaa
      kbd
      #(nerdfonts.override { fonts = [ "InconsolataGo" "FiraCode" "DroidSansMono" "Terminus" ]; })
    ];
    fontconfig.antialias = false;
  };
  system.stateVersion = "23.11"; # Did you read the comment?
  nixpkgs.config = { 
    allowUnfree = true;
    allowBroken = true;
  };
  nix.settings = {
    sandbox = true;
    experimental-features = [ "nix-command" "flakes" ];
  };
  zramSwap.enable = true;
  virtualisation = {
    podman = {
      enable = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };
}


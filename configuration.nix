{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  services = {
    xserver = {
      enable = true;
      desktopManager.xfce = {
        enable = true;
      };
      xkb.layout = "us";
      videoDrivers = [ "nvidia" "modesetting" ];
    };
    
    libinput.enable = true;
    blueman.enable = true;
    fractalart.enable = true;
  };

  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    nameservers = [ "208.67.222.222" "208.67.220.220" "114.114.114.114" "114.114.115.115" "223.5.5.5" "114.215.126.16" "8.8.8.8" "8.8.4.4" "1.1.1.1" ];
    firewall.allowedTCPPorts = [ 22 8000 ];
  };

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      substituters = [ "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store" ];
    };
  };

  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };

    pulseaudio.enable = true;

    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };

    nvidia = {
	    prime = {
        offload = { enable = true; enableOffloadCmd = true; };
        #sync.enable = true;
        amdgpuBusId = "PCI:4:0:0";
        nvidiaBusId = "PCI:1:0:0";
      };
      package = config.boot.kernelPackages.nvidiaPackages.beta;
      modesetting.enable = true;
      powerManagement.enable = true;
      powerManagement.finegrained = true;
      nvidiaPersistenced = true;
      nvidiaSettings = true;
    };
  };
  
  # Set your time zone.
  time.timeZone = "Asia/Shanghai";
  
  programs = {
    clash-verge = {
      enable = true;
      tunMode = true;
      autoStart = true;
    };
    
    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        stdenv.cc.cc.lib
        libGL      
        glib
      ];
    };

    git = {
      enable = true;
      config = {
        user.email = "1461200635@qq.com";
        user.name = "Peerin";
      };
    };
  };

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
    supportedLocales = [ "en_US.UTF-8/UTF-8" "zh_CN.UTF-8/UTF-8" ];
    inputMethod = {
      enabled = "fcitx5";
      fcitx5.addons = with pkgs; [ fcitx5-rime fcitx5-chinese-addons ];
    };
  };
  
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true; # use xkbOptions in tty.
  };

  # Enable sound.
  sound.enable = true;

  nixpkgs = {
    config.allowUnfree = true;
  };

  users.users = {
    peerin = {
      isNormalUser = true;
      extraGroups = [ "wheel" "audio" ];
      packages = with pkgs; [];
      initialPassword = "pw123";
    };
  };

  environment = {
     systemPackages = with pkgs; [
       emacs
       firefox
       tree
       zip
       unzrip
       curl
       wget
     ];
   };

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    wqy_microhei
    wqy_zenhei
    unifont
    source-han-mono
    source-han-serif
    source-han-sans
  ];

  system = {
    ########################
    stateVersion = "23.05";#
    ########################
  };
}


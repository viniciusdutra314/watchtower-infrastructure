{ config, pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config = {
    permittedInsecurePackages = [
      "firefox-esr-140-bin-unwrapped-140.17.0esr"
    ];
  };
  news.display = "silent";
  home.username = "vinicius";
  home.homeDirectory = "/home/vinicius";
  home.stateVersion = "26.05";

  xdg.configFile."sway/config.d/90-bar.conf".text = ''
    # Waybar iniciada pelo Home Manager/Sway.
    # Desativa a barra padrão do Fedora.
  '';
  targets.genericLinux.enable = true; # make GPU acceleration work
  home.sessionVariables.GTK_IM_MODULE = "simple"; # make ~ work in ghostty

  home.file = {
    ".local/bin/wt-codium" = {
      source = ../scripts/wt-codium.py;
      executable = true;
    };

    ".local/bin/wt-zed" = {
      source = ../scripts/wt-zed.py;
      executable = true;
    };
  };

  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/.juliaup/bin"
  ];

  home.packages = with pkgs; [
    audacity
    bitwarden-desktop
    blanket
    flatpak
    flameshot
    gnome-clocks
    gnome-network-displays
    kdePackages.okular
    obs-studio
    saber
    telegram-desktop
    virt-manager
    vlc
    woomer
    zapzap
    zotero
  ];

  programs.home-manager.enable = true;

  imports = [
    ./sway.nix
    ../common/zsh.nix
    ./ssh.nix
    ./waybar.nix
    ../common/develop.nix
    ./commands.nix
    ./flatpaks.nix
  ];
}

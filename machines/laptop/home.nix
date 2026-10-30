{ config, pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;
  home.username = "vinicius";
  home.homeDirectory = "/home/vinicius";
  home.stateVersion = "26.05";
  programs.zed-editor = {
    enable = true;
    package = pkgs.zed-editor;
  };

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
  ];

  programs.vscodium = {
    enable = true;
    package = pkgs.vscodium;
    mutableExtensionsDir = true;
  };
  home.packages = with pkgs; [
    nixd
    nil
    nixfmt
    git
    git-lfs
    gh
    ripgrep
    bat
    jujutsu
    typst
    just
    rustup
    uv
    zig
    jq
    cloc
    direnv
    nix-direnv
    hyperfine
    zed-editor
    vscodium
    btop
    tmux
    tree
    fastfetch

    imagemagick
    yt-dlp

    saber
    bitwarden-desktop
    blanket
    audacity
    kdePackages.okular
    telegram-desktop
    vlc
  ];
  programs.home-manager.enable = true;
}

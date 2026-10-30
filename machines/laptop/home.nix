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
  targets.genericLinux.enable = true; #make GPU acceleration work
  programs.ghostty = {
    enable = true;
    package = pkgs.ghostty;
    enableBashIntegration = true;
    settings = {
      background-opacity = 0.95;
      font-size = 18;
      term = "xterm-256color";
    };
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
    audacity
    bat
    bitwarden-desktop
    blanket
    btop
    cloc
    direnv
    fastfetch
    gh
    git
    git-lfs
    hyperfine
    imagemagick
    jq
    jujutsu
    just
    kdePackages.okular
    nil
    nix-direnv
    nixd
    nixfmt
    ripgrep
    rustup
    saber
    telegram-desktop
    tmux
    tree
    typst
    uv
    vlc
    vscodium
    yt-dlp
    zed-editor
    zig
  ];
  programs.home-manager.enable = true;
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
  imports = [
    ./sway.nix
    ./zsh.nix
    ./ssh.nix
  ];
}

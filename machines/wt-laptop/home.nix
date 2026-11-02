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

  programs.zed-editor = {
    enable = true;
    package = pkgs.zed-editor;
    mutableUserSettings = true;
    extensions = [
      "nix"
      "typst"
      "toml"
    ];
    extraPackages = with pkgs; [
      nixd
      nixfmt
    ];
    userSettings = {
      disable_ai = true;
      telemetry = {
        metrics = false;
        diagnostics = false;
      };
      load_direnv = "direct";
      languages.Nix = {
        language_servers = [
          "nixd"
          "!nil"
        ];
        format_on_save = "on";

        formatter.external = {
          command = "nixfmt";
          arguments = [ ];
        };
      };
    };
  };
  xdg.configFile."sway/config.d/90-bar.conf".text = ''
    # Waybar iniciada pelo Home Manager/Sway.
    # Desativa a barra padrão do Fedora.
  '';
  targets.genericLinux.enable = true; # make GPU acceleration work
  home.sessionVariables.GTK_IM_MODULE = "simple"; # make ~ work in ghostty
  programs.ghostty = {
    enable = true;
    package = pkgs.ghostty;
    enableZshIntegration = true;
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
    "$HOME/.juliaup/bin"
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
    flatpak
    flameshot
    gh
    git
    git-lfs
    gnome-clocks
    hyperfine
    imagemagick
    jq
    jujutsu
    just
    kdePackages.okular
    nil
    nixd
    nixfmt
    obs-studio
    ripgrep
    rustup
    saber
    telegram-desktop
    tmux
    tree
    typst
    uv
    vlc
    yt-dlp
    woomer
    zapzap
    gnome-clocks
    zig
    zotero
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
    ./waybar.nix
    
    ./flatpaks.nix
  ];
}

{ config, pkgs, ... }:
{
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
  programs.vscodium = {
    enable = true;
    package = pkgs.vscodium;
    mutableExtensionsDir = true;
  };
  programs.ghostty = {
    enable = true;
    package = pkgs.ghostty;
    enableZshIntegration = true;
    settings = {
      background-opacity = 0.95;
      working-directory = "${config.home.homeDirectory}/watchtower-up/machines";
      window-inherit-working-directory = false;
      font-size = 18;
      term = "xterm-256color";
    };
  };
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/.juliaup/bin"
  ];
  home.packages = with pkgs; [
    bat
    btop
    cloc
    cmake
    direnv
    fastfetch
    gdb
    gh
    ghc
    git
    git-lfs
    gnumake
    hyperfine
    imagemagick
    jq
    jujutsu
    just
    lldb
    ninja
    nixd
    nixfmt
    ripgrep
    rustup
    texliveFull
    tmux
    tree
    typst
    uv
    yt-dlp
    zig
  ];
}

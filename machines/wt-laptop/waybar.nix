{ pkgs, lib, ... }:

let
  # Forçar fonte para caracteres que não renderizam corretamente.
  punctuation = char: "<span font_family='DejaVu Sans'>${char}</span>";

  watchtowerStatus = pkgs.writeShellScript "watchtower-status" ''
    if ! status="$(${pkgs.tailscale}/bin/tailscale status --json 2>/dev/null)"; then
      echo '{"text":"WT ?","class":"unknown","tooltip":"Tailscale indisponível"}'
    elif echo "$status" | ${pkgs.jq}/bin/jq -e \
      'any(.Peer[]?; .HostName == "watchtower" and .Online == true)' \
      >/dev/null 2>&1; then
      echo '{"text":"WT <span font_family=\"DejaVu Sans\">●</span>","class":"online","tooltip":"Watchtower online no Tailscale"}'
    else
      echo '{"text":"WT <span font_family=\"DejaVu Sans\">●</span>","class":"offline","tooltip":"Watchtower offline no Tailscale"}'
    fi
  '';
in
{
  home.packages = [ pkgs.font-awesome ];
  fonts.fontconfig.enable = true;

  programs.waybar = {
    enable = true;

    settings.mainBar = {
      layer = "top";
      position = "top";
      height = 34;
      spacing = 6;

      modules-left = [ "sway/workspaces" ];
      modules-center = [ "sway/window" ];
      modules-right = [
        "custom/watchtower"
        "cpu"
        "memory"
        "pulseaudio"
        "power-profiles-daemon"
        "battery"
        "tray"
        "clock#date"
        "clock#time"
      ];

      "sway/workspaces" = {
        disable-scroll = true;
        all-outputs = true;
      };

      "sway/window".max-length = 40;

      "custom/watchtower" = {
        exec = watchtowerStatus;
        return-type = "json";
        interval = 30;
      };

      cpu = {
        format = " {usage}${punctuation "%"}";
        interval = 5;
      };

      memory = {
        format = " {percentage}${punctuation "%"}";
        interval = 10;
      };

      pulseaudio = {
        format = "{icon} {volume}${punctuation "%"}";
        format-muted = " Mute";
        format-icons.default = [
          ""
          ""
          ""
        ];
        scroll-step = 5;
        on-click = "${pkgs.pavucontrol}/bin/pavucontrol";
      };

      "power-profiles-daemon" = {
        format = "{icon}";
        tooltip-format = "Perfil de energia: {profile}";
        format-icons = {
          "power-saver" = "";
          balanced = "";
          performance = "";
        };
      };

      battery = {
        format = "{icon} {capacity}${punctuation "%"}";
        format-charging = " {icon} {capacity}${punctuation "%"}";
        format-plugged = " {icon} {capacity}${punctuation "%"}";
        format-full = " {capacity}${punctuation "%"}";
        format-icons = [
          ""
          ""
          ""
          ""
          ""
        ];
        interval = 5;
        tooltip-format = "{timeTo}";
      };

      tray.spacing = 8;

      "clock#date" = {
        format = " {0:%d}${punctuation "/"}{0:%m}${punctuation "/"}{0:%Y}";
        tooltip-format = "{:%A, %d de %B de %Y}";
        on-click = "thunderbird -calendar";
      };

      "clock#time" = {
        format = " {0:%H}${punctuation ":"}{0:%M}";
        tooltip = false;
        on-click = "thunderbird -calendar";
      };
    };

    style = ''
      /* Catppuccin Frappé */
      @define-color base #303446;
      @define-color text #c6d0f5;
      @define-color subtext0 #a5adce;
      @define-color surface1 #51576d;
      @define-color blue #8caaee;
      @define-color mauve #ca9ee6;
      @define-color peach #ef9f76;
      @define-color green #a6d189;
      @define-color red #e78284;
      @define-color yellow #e5c890;

      * {
        font-family: "DejaVu Sans", "Font Awesome 7 Free", "Font Awesome 6 Free";
        font-size: 12px;
        border: none;
      }

      window#waybar {
        background-color: @base;
        color: @text;
        border-bottom: 1px solid @surface1;
      }

      #workspaces button {
        padding: 0 8px;
        background-color: transparent;
        color: @subtext0;
      }

      #workspaces button.active,
      #workspaces button.focused {
        background-color: @blue;
        color: @base;
      }

      #window { color: @subtext0; }

      #window, #cpu, #memory, #pulseaudio,
      #power-profiles-daemon, #battery, #tray,
      #clock, #custom-watchtower {
        padding: 0 7px;
      }

      #cpu { color: @blue; }
      #memory { color: @mauve; }
      #pulseaudio { color: @peach; }

      #battery { color: @green; }
      #battery.charging { color: @yellow; }
      #battery.plugged { color: @blue; }

      #power-profiles-daemon.power-saver { color: @green; }
      #power-profiles-daemon.balanced { color: @blue; }
      #power-profiles-daemon.performance { color: @peach; }

      #clock { color: @text; }
      #clock.time {
        border-left: 1px solid @surface1;
        margin-left: 5px;
        padding-left: 12px;
      }

      #custom-watchtower.online { color: @green; }
      #custom-watchtower.offline { color: @red; }
      #custom-watchtower.unknown { color: @yellow; }
    '';
  };

  wayland.windowManager.sway.config = {
    bars = lib.mkForce [ ];
    startup = [
      { command = "${pkgs.waybar}/bin/waybar"; }
    ];
  };
}

{lib, ... }:

let
  mod = "Mod4";
in
{
  wayland.windowManager.sway = {
    enable = true;
    package = null; 
    systemd.enable = false;

    config = {
      modifier = mod;
      terminal = "ghostty";
      menu = "rofi -terminal 'ghostty' -show combi -combi-modes drun#run -modes combi";
      workspaceLayout = "tabbed";
      bars = [ ]; # A configuração da distribuição cuida da barra.

      window = {
        titlebar = false;
        border = 0;
        hideEdgeBorders = "--i3 both";
      };
      gaps = {
        smartBorders = "on";
        smartGaps = "on";
      };
      input."type:keyboard".xkb_layout = "br";

      output = {
        "*".bg = "/home/vinicius/Pictures/Wallpaper/forest.jpg fill";
        "eDP-1" = {
          mode = "1920x1080@60Hz";
          position = "0 0";
        };
        "HDMI-A-2" = {
          mode = "1920x1080@144Hz";
          position = "1920 0";
        };
      };

      bindswitches = {
        "lid:on" = {
          locked = true;
          reload = true;
          action = "output eDP-1 disable";
        };
        "lid:off" = {
          locked = true;
          reload = true;
          action = "output eDP-1 enable";
        };
      };

      assigns = {
        "1" = [
          { app_id = "org.mozilla.firefox"; }
          { app_id = "ai-voice-usage"; }
        ];
        "9" = [ { app_id = "org.mozilla.thunderbird_esr"; } ];
        "10" = [
          { app_id = "org.telegram.desktop"; }
          { app_id = "com.rtosta.zapzap"; }
          { app_id = "spotify"; }
        ];
      };

      startup = map (command: { inherit command; }) [
        "firefox"
        "flatpak run org.mozilla.thunderbird_esr"
        "flatpak run org.telegram.desktop"
        "flatpak run com.rtosta.zapzap"
        "ai-voice-usage"
      ];

      keybindings = lib.mkOptionDefault {
        "${mod}+q" = "kill";
        "${mod}+Shift+q" = null;
        "Print" = "exec flatpak run org.flameshot.Flameshot gui --raw | wl-copy --type image/png";
        "${mod}+Shift+p" = "exec swaymsg -t command";
      };
    };

    extraConfig = ''
      set $mod ${mod}
      exec swayidle -w \
        timeout 1800 'swaylock -f' \
        timeout 1800 'systemd-ac-power || systemctl suspend' \
        before-sleep 'swaylock -f'

      # Mantém as configurações em camadas do Sway no Fedora.
      include '$(/usr/libexec/sway/layered-include "/usr/share/sway/config.d/*.conf" "/etc/sway/config.d/*.conf" "''${XDG_CONFIG_HOME:-$HOME/.config}/sway/config.d/*.conf")'
    '';
  };
}

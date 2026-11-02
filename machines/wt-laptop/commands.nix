
{ pkgs, ... }:

let
  confirm = label: command:
    pkgs.writeShellScript "wt-confirm-action" ''
      choice="$(
        printf '%s\n' "Cancelar" "Confirmar" |
          ${pkgs.fuzzel}/bin/fuzzel \
            --dmenu \
            --prompt "${label}? " \
            --lines 2
      )" || exit 0

      [ "$choice" = "Confirmar" ] || exit 0
      exec ${command}
    '';
in
{
  xdg.desktopEntries = {
    wt-shutdown = {
      name = "Shutdown";
      icon = "system-shutdown";
      exec = "${confirm "Desligar" "${pkgs.systemd}/bin/systemctl poweroff"}";
      categories = [ "System" ];
      settings.Keywords = "poweroff;shutdown;energia;";
    };

    wt-reboot = {
      name = "Reboot";
      icon = "system-reboot";
      exec = "${confirm "Reiniciar" "${pkgs.systemd}/bin/systemctl reboot"}";
      categories = [ "System" ];
      settings.Keywords = "restart;reboot;energia;";
    };

    wt-suspend = {
      name = "Suspend";
      icon = "system-suspend";
      exec = "${pkgs.systemd}/bin/systemctl suspend";
      categories = [ "System" ];
      settings.Keywords = "sleep;suspend;energia;";
    };

    wt-logout = {
      name = "Logout";
      icon = "system-log-out";
      exec = "${confirm "Sair do Sway" "${pkgs.sway}/bin/swaymsg exit"}";
      categories = [ "System" ];
      settings.Keywords = "logout;sair;energia;";
    };
  };

  programs.fuzzel.settings.main.fields =
    "filename,name,generic,keywords";
}

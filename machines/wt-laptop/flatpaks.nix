
{ config,... }:
{
  xdg.systemDirs.data = [
    "/var/lib/flatpak/exports/share"
    "${config.home.homeDirectory}/.local/share/flatpak/exports/share"
  ];
  services.flatpak = {
    enable = true;
    
    packages = [
      "org.mozilla.thunderbird"
      "com.spotify.Client"
      "com.github.tchx84.Flatseal"
      "io.github.flattool.Warehouse" 
    ];

    uninstallUnmanaged = false;

    update.auto = {
      enable = true;
      onCalendar = "weekly";
    };
  };
}

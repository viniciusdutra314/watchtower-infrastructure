
{ ... }:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
      wt-unlock = {
        HostName = "192.168.0.100";
        User = "root";
        Port = 2222;
        IdentityFile = "~/.ssh/watchtower-main-initrd";
        IdentitiesOnly = true;
      };
      wt-server = {
        HostName = "wt-server";
        User = "vinicius";
        IdentityFile = "~/.ssh/id_ed25519_wt_server";
        IdentitiesOnly = true;
      };

      wt-dev = {
        HostName = "wt-dev";
        User = "chloe";
        IdentityFile = "~/.ssh/id_ed25519_watchtower_chloe";
        IdentitiesOnly = true;
      };
    };
  };
}

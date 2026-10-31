{ ... }:

{
  nixpkgs.hostPlatform = "x86_64-linux";

  # Fedora ainda não é uma distribuição oficialmente testada.
  system-manager.allowAnyDistro = true;

  # Não assumir o controle do Nix instalado no Fedora.
  nix.enable = false;

  # Primeiro teste de ativação.
  environment.etc."watchtower-system-manager-test".text = ''
    Managed by System Manager.
  '';
}

{
  description = "Watchtower Infrastructure";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    system-manager = {
      url = "github:numtide/system-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      system-manager,
      ...
    }:
    {
      homeConfigurations.wt-laptop = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        modules = [
          ./wt-laptop/home.nix
        ];
      };
      systemConfigs.laptop = system-manager.lib.makeSystemConfig {
        modules = [ ./wt-laptop/system.nix ];
      };

      apps.x86_64-linux.system-manager = {
        type = "app";
        program = "${system-manager.packages.x86_64-linux.default}/bin/system-manager";
      };

    };
}

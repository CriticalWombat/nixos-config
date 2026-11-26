{
  description = "Luke's NixOS + Hyprland desktop(s)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";

      mkHost = hostConfig: nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [
          hostConfig
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              # Pre-existing plain files (old hyprland.lua symlink, GTK
              # defaults, etc) get moved aside as *.hm-backup instead of
              # blocking activation.
              backupFileExtension = "hm-backup";
              extraSpecialArgs = { inherit inputs; };
              users.luke = import ./modules/home;
            };
          }
        ];
      };
    in
    {
      nixosConfigurations = {
        nix-e14 = mkHost ./hosts/nix-e14/configuration.nix;

        # Future desktop host -- scaffolded in hosts/desktop/, not active.
        # See hosts/desktop/configuration.nix for activation steps, then:
        # desktop = mkHost ./hosts/desktop/configuration.nix;
      };
    };
}

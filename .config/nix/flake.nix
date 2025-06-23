{
  description = "Zenful Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    mac-app-util.url = "github:hraban/mac-app-util";
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
  };

  outputs = inputs@{ self, nix-darwin, nix-homebrew, mac-app-util, ... }: {
    darwinConfigurations = {
      studio = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = { inherit self; };
        modules = [
          ./hosts/darwin/mac-studio/default.nix
          mac-app-util.darwinModules.default
          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              enable = true;
              user = "seleneblok";
              enableRosetta = true;
            };
          }
        ];
      };

      work = nix-darwin.lib.darwinSystem {
        system = "x86_64-darwin";
        specialArgs = { inherit self; };
        modules = [
          ./hosts/darwin/work-laptop/default.nix
          mac-app-util.darwinModules.default
          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              enable = true;
              user = "seleneblok";
            };
          }
        ];
      };
    };
  };
}

{
  description = "Noctalia shell - a Wayland desktop shell built with Quickshell";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs = {
    self,
    nixpkgs,
    ...
  }: let
    eachSystem = nixpkgs.lib.genAttrs ["x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin"];
  in {
    formatter = eachSystem (system: nixpkgs.legacyPackages.${system}.alejandra);

    packages = eachSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        default = pkgs.callPackage ./nix/package.nix {
          version = self.rev or self.dirtyRev or "dirty";
          inherit (pkgs) quickshell;
        };
      }
    );

    defaultPackage = eachSystem (system: self.packages.${system}.default);

    devShells = eachSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        default = pkgs.callPackage ./shell.nix {};
      }
    );

    homeModules.default = {
      pkgs,
      lib,
      ...
    }: {
      imports = [./nix/home-module.nix];
      programs.noctalia-shell.package = lib.mkDefault self.packages.${pkgs.system}.default;
      programs.noctalia-shell.app2unit.package =
        lib.mkDefault
        nixpkgs.legacyPackages.${pkgs.system}.app2unit;
    };

    nixosModules.default = {
      pkgs,
      lib,
      ...
    }: {
      imports = [./nix/nixos-module.nix];
      services.noctalia-shell.package = lib.mkDefault self.packages.${pkgs.system}.default;
    };
  };
}

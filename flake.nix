{
	description = "NixOS Configuration";

	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
		nixpkgsUnstable.url = "github:NixOS/nixpkgs/nixos-unstable";
	};

	outputs = { self, nixpkgs, nixpkgsUnstable, ... }:
	let
		system = "x86_64-linux";
		pkgsUnstable = nixpkgsUnstable.legacyPackages.${system};
	in {
		nixosConfigurations = {
			xansaware = nixpkgs.lib.nixosSystem {
				inherit system;
				specialArgs = {
					inherit pkgsUnstable;
				};
				modules = [ ./configuration.nix ];
			};
		};
	};
}

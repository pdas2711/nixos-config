{
	description = "NixOS Configuration";

	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
		xansapkgs.url = "github:pdas2711/xansapkgs";
		nixpkgsUnstable.url = "github:NixOS/nixpkgs/nixos-unstable";
		nixosHardware.url = "github:NixOS/nixos-hardware/master";
	};

	outputs = { self, xansapkgs, nixpkgs, nixpkgsUnstable, nixosHardware, ... }: {
		nixosConfigurations = {
			xansaware = nixpkgs.lib.nixosSystem {
				system = "x86_64-linux";
				specialArgs = {
					pkgsUnstable = nixpkgsUnstable.legacyPackages."x86_64-linux";
					xansapkgs = xansapkgs.packages."x86_64-linux";
				};
				modules = [ ./hosts/xansaware/configuration.nix ];
			};
			xwpi = nixpkgs.lib.nixosSystem {
				system = "aarch64-linux";
				modules = [
					"${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64-new-kernel-no-zfs-installer.nix"
					nixosHardware.nixosModules.raspberry-pi-4
					./hosts/xwpi/configuration.nix
				];
			};
			xwserver = nixpkgs.lib.nixosSystem {
				system = "x86_64-linux";
				specialArgs = {
					pkgsUnstable = nixpkgsUnstable.legacyPackages."x86_64-linux";
				};
				modules = [ ./hosts/xwserver/configuration.nix ];
			};
			xwgo = nixpkgs.lib.nixosSystem {
				system = "x86_64-linux";
				specialArgs = {
					pkgsUnstable = nixpkgsUnstable.legacyPackages."x86_64-linux";
				};
				modules = [ ./hosts/xwgo/configuration.nix ];
			};
		};
	};
}

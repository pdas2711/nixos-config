{
	description = "NixOS Configuration";

	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
		nixpkgsUnstable.url = "github:NixOS/nixpkgs/nixos-unstable";
		nixos-hardware.url = "github:NixOS/nixos-hardware/master";
	};

	outputs = { self, nixpkgs, nixpkgsUnstable, nixos-hardware, ... }: {
		nixosConfigurations = {
			xansaware = nixpkgs.lib.nixosSystem {
				system = "x86_64-linux";
				specialArgs = {
					pkgsUnstable = nixpkgsUnstable.legacyPackages."x86_64-linux";
				};
				modules = [ ./configuration.nix ];
			};
			xansawarejb = nixpkgs.lib.nixosSystem {
				system = "aarch64-linux";
				modules = [
					"${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64-new-kernel-no-zfs-installer.nix"
					nixos-hardware.nixosModules.raspberry-pi-4
					./xansawarejb/configuration.nix
				];
			};
			xansaserver = nixpkgs.lib.nixosSystem {
				system = "x86_64-linux";
				modules = [ ./xansaspire/configuration.nix ];
			};
		};
	};
}

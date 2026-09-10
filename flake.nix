{
	description = "NixOS Configuration";

	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
		xwpkgs.url = "github:pdas2711/xwpkgs";
		nixpkgsUnstable.url = "github:NixOS/nixpkgs/nixos-unstable";
		nixosHardware.url = "github:NixOS/nixos-hardware/master";
		hyprland.url = "github:hyprwm/Hyprland";
		hyprland_scroll_overview.url = "github:yayuuu/hyprland-scroll-overview";
	};

	outputs = { self, xwpkgs, nixpkgs, nixpkgsUnstable, nixosHardware, ... }@inputs: {
		nixosConfigurations = {
			xansaware = nixpkgs.lib.nixosSystem {
				system = "x86_64-linux";
				specialArgs = {
					inherit inputs;
					pkgsUnstable = nixpkgsUnstable.legacyPackages."x86_64-linux";
					xwpkgs = xwpkgs.packages."x86_64-linux";
				};
				modules = [ ./hosts/xansaware/configuration.nix ];
			};
			xwpi = nixpkgs.lib.nixosSystem {
				system = "aarch64-linux";
				specialArgs = { inherit inputs; };
				modules = [
					"${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64-new-kernel-no-zfs-installer.nix"
					nixosHardware.nixosModules.raspberry-pi-4
					./hosts/xwpi/configuration.nix
				];
			};
			xwserver = nixpkgs.lib.nixosSystem {
				system = "x86_64-linux";
				specialArgs = {
					inherit inputs;
					pkgsUnstable = nixpkgsUnstable.legacyPackages."x86_64-linux";
				};
				modules = [ ./hosts/xwserver/configuration.nix ];
			};
			xwgo = nixpkgs.lib.nixosSystem {
				system = "x86_64-linux";
				specialArgs = {
					inherit inputs;
					pkgsUnstable = nixpkgsUnstable.legacyPackages."x86_64-linux";
				};
				modules = [ ./hosts/xwgo/configuration.nix ];
			};
		};
	};
}

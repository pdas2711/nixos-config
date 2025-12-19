{ config, inputs, lib, pkgs, pkgsUnstable, ... }: {
	imports = [
		../../common/misc.nix
		../../common/applications.nix
		../../common/services.nix
		../../common/desktop.nix
		../../common/grub.nix
		../../common/initrd_crypt_askpass.nix
		../../common/networking.nix
		../../common/wireless.nix
		../../common/bluetooth.nix
		../../common/wireguard.nix
		./filesystems.nix
	];

	# Hostname
	networking.hostname = "xansago";

	# Enable touchpad support
	services.libinput.enable = true;

	# Main user
	users.users = {
		pdas2711 = {
			isNormalUser = true;
			extraGroups = [ "wheel" "power-timer" ];
			createHome = true;
		};
	};

	# Add power-timer script
	environment.systemPackages = [
		(import (../../addons/power_timer.nix) { inherit pkgs; })
	];

	system.stateVersion = "24.11";
}

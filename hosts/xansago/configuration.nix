{ config, inputs, lib, pkgs, pkgsUnstable, ... }: {
	let
		common_dir = ../../common;
	in
		imports = [
			common_dir + ./misc.nix
			common_dir + ./applications.nix
			common_dir + ./services.nix
			common_dir + ./desktop.nix
			common_dir + ./grub.nix
			common_dir + ./initrd_crypt_askpass.nix
			common_dir + ./networking.nix
			common_dir + ./wireless.nix
			common_dir + ./bluetooth.nix
			common_dir + ./wireguard.nix
			addons_dir + ./power_timer.nix
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
	let
		addons_dir = ../../addons;
	in
		environment.systemPackages = [
			(import (addons_dir + ./power_timer.nix) { inherit pkgs; })
		];

	system.stateVersion = "24.11";
}

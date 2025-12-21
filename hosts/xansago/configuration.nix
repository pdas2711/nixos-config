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
		../../addons/power_timer.nix
		./filesystems.nix
		./hardware.nix
	];

	# Hostname
	networking.hostName = "xansago";

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

	system.stateVersion = "24.11";
}

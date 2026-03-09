{ config, lib, pkgs, pkgsUnstable, ... }: {
	imports = [
		../../common/misc.nix
		../../common/base_applications.nix
		../../common/services.nix
		../../common/initrd_crypt_askpass.nix
		../../common/grub.nix
		../../common/networking.nix
		../../common/wireless.nix
		./filesystems.nix
		./hardware.nix

	];
	
	# This host does not support custom EFI names
	boot.loader.grub.efiInstallAsRemovable = true;

	# Hostname
	networking.hostName = "xansaserver";

	# Enable touchpad support
	services.libinput.enable = true;
	
	# Main User
	users.user = {
		pdas2711 = {
			isNormalUser = true;
			extraGroups = [ "wheel" ];
			createHome = true;
		};
	};

	# System-wide Packages
	environment.systemPackages = with pkgs; [
		brightnessctl
	];

	# Always-online Ntfy Server
	services.ntfy-sh = {
		enable = true;
		settings = {
			base-url = "http://xansaware.ddns.net";
			listen-http = ":7778";
			auth-file = "/var/lib/ntfy-sh/user.db";
			auth-default-access = "read-write";
		};
	};

	# Filebrowser
	services.filebrowser = {
		enable = true;
		settings.address = "0.0.0.0";
		openFirewall = true;
	};

	system.stateVersion = "24.11";
}

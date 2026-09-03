{ config, lib, pkgs, pkgsUnstable, ... }: {
	imports = [
		../../common/misc.nix
		../../common/base_applications.nix
		../../common/additional_applications.nix
		../../common/remote.nix
		../../common/grub.nix
		../../common/networking.nix
		../../common/wireless.nix
		../../common/bluetooth.nix
		./filesystems.nix
		./hardware.nix

	];
	
	# This host does not support custom EFI names
	boot.loader.grub.efiInstallAsRemovable = true;

	# Hostname
	networking.hostName = "xwserver";

	# Enable touchpad support
	services.libinput.enable = true;

	# Do nothing when the lid is closed since the host is a server running on a laptop
	services.logind.settings.Login.HandleLidSwitch = "ignore";
	
	# Main User
	users.users = {
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

	# Monero Node
	services.monero = {
		enable = true;
		rpc = {
			address = "0.0.0.0";
			port = 18089;
			restricted = true;
		};
		extraConfig = ''
		public-node=1
		confirm-external-bind=1
		'';
	};

	# Firewall
	networking.firewall = {
		enable = true;
		allowedTCPPorts = [
			18080  # Monero P2P
			18089  # Restricted RPC
		];
	};

	system.stateVersion = "24.11";
}

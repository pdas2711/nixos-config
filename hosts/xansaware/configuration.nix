{ config, inputs, lib, pkgs, pkgsUnstable, ... }: {
	imports = [
		../../common/misc.nix
		../../common/base_applications.nix
		../../common/additional_applications.nix
		../../common/services.nix
		../../common/desktop.nix
		../../common/grub.nix
		../../common/initrd_crypt_askpass.nix
		../../common/initrd_network.nix
		../../common/networking.nix
		../../common/wireless.nix
		../../common/bluetooth.nix
		../../common/wireguard.nix
		../../addons/power_timer.nix
		../../addons/git_server.nix
		./filesystems.nix
		./hardware.nix
	];

	# Hostname
	networking.hostName = "xansaware";

	# Initrd Network Access for LUKS and QEMU Emulation
	boot = {
		kernelParams = [ "ip=169.168.1.1::169.168.1.0:255.255.255.252::enp6s0:off" ];
		binfmt.emulatedSystems = [ "aarch64-linux" ];  # For QEMU emulation of other architectures
	};
		
	# Change Power Button behavior to Sleep on short-press
	services.logind.settings.Login = {
		HandlePowerKey = "suspend";
	};

	# Users
	users.users = {
		pdas2711 = {
			isNormalUser = true;
			extraGroups = [ "wheel" "libvirtd" "power-timer" ];
			createHome = true;
		};
		guest = {
			isNormalUser = true;
			createHome = true;
		};
	};

	# Increased download buffer size
	nix.settings.download-buffer-size = 524288000;

	# Ignore 2FA for members in group 'ignoreoath'
	users.groups.ignoreoath.members = [ "git" ];

	# Steam
	programs.steam = {
		enable = true;
		remotePlay.openFirewall = true;
		dedicatedServer.openFirewall = true;
	};

	# Allowing Unfree Packages
	nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
	     "steam"
	     "steam-unwrapped"
	];

	# Radicale CalDAV/CardDav Server
	services.radicale = {
		enable = true;
		settings = {
			server.hosts = [ "0.0.0.0:5232" ];
			auth = {
				type = "htpasswd";
				htpasswd_filename = "/var/lib/radicale/users";
				htpasswd_encryption = "bcrypt";
			};
			storage.filesystem_folder = "/var/lib/radicale/collections";
		};
	};
	
	# Jellyfin Media Server
	services.jellyfin = {
		enable = true;
		openFirewall = true;
	};

	# NTFY Notification Server
	services.ntfy-sh = {
		enable = true;
		settings = {
			base-url = "http://xansaware.ddns.net";
			listen-http = ":7777";
			auth-file = "/var/lib/ntfy-sh/user.db";
			auth-default-access = "read-write";
		};
	};

	# Nginx Web Server
	services.nginx = {
		enable = true;
		virtualHosts = {
			"localhost".root = "/var/www";
		};
	};

	# Filebrowser
	services.filebrowser = {
		enable = true;
		settings.address = "0.0.0.0";
		openFirewall = true;
		user = "root";
	};
	
	# Crypttab Configuration
	environment.etc.crypttab.text = ''backup_root	/dev/disk/by-uuid/823f75c2-3c8b-4ebd-b20c-3ac86de1028f	/var/lib/private/luks_keys/backup_drive.key
jellyfin	/dev/disk/by-uuid/9b514292-923a-4852-8556-2bb9c77346d9	/var/lib/private/luks_keys/jellyfin.key
backup_jellyfin	/dev/disk/by-uuid/d9fa1d9a-86dd-4d89-b9d5-9254f27b7186	/var/lib/private/luks_keys/jellyfin.key
	'';
	
	# Open ports in the firewall.
	networking.firewall = {
		enable = true;
		allowedTCPPorts = [
			7777  # Ntfy
			5232  # Radicale
			80  # Nginx
		];
	};
	
	# Interface Setup for Wireguard
	networking.nat.externalInterface = "enp5s0";

	# Network Interface Setup
	networking.interfaces.enp5s0.useDHCP = lib.mkDefault true;
	networking.interfaces.enp6s0 = {  # Internal network with xansapi (direct Ethernet connection)
		useDHCP = false;
		ipv4.addresses = [ {
			address = "169.168.1.1";
			prefixLength = 30;
		} ];
	};
	networking.interfaces.wlan0.useDHCP = lib.mkDefault true;
	networking.networkmanager.unmanaged = [ "interface-name:enp6s0" ];
	
	# System-wide Packages
	environment.systemPackages = with pkgs; [
		yt-dlp
		flac
		openjdk
		obs-studio
		mesa-demos
		jellyfin-web
		jellyfin-ffmpeg
		jellycli
		pandoc
		firefox
		imagemagick
		texlive.combined.scheme-medium
		gimp
	];
	
	# System State
	system.stateVersion = "24.11";
}

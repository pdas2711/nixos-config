# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, pkgsUnstable, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

	# Boot Configuration
	boot = {
		loader = {
			# Use Grub for the bootloader.
			grub = {
				enable = true;
				efiSupport = true;
				efiInstallAsRemovable = true;
				device = "nodev";
			};
		};

		initrd = {
			systemd.users.root.shell = "/bin/cryptsetup-askpass";
		};
	};

	networking = {
		hostName = "xansaserver"; # Define your hostname.
		wireless.iwd.enable = true;  # Enables wireless support via iwd.
		networkmanager = {
			enable = true;  # Easiest to use and most distros use this by default.
			wifi.backend = "iwd";
		};
	};

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
    # useXkbConfig = true; # use xkb.options in tty.
  };

  # Enable sound.
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

	# Enable touchpad support
	services.libinput.enable = true;

	# Default shell for all users
	users.defaultUserShell = pkgs.zsh;

	# Define a user account. Don't forget to set a password with ‘passwd’.
	users.mutableUsers = true;
	users.users = {
		pdas2711 = {
			isNormalUser = true;
			extraGroups = [ "wheel" ];
			createHome = true;
			packages = with pkgs; [];
		};
	};

	# Enable Flakes
	nix.settings.experimental-features = [ "nix-command" "flakes" ];

	# Enabling applications
	programs.zsh = {
		enable = true;
		syntaxHighlighting.enable = true;
	};

	# List packages installed in system profile. To search, run:
	# $ nix search wget
	environment.systemPackages = with pkgs; [
		fastfetch
		flatpak
		neovim
		tmux
		wget
		zsh
		git
		pkgsUnstable.git-filter-repo
		gnupg
		pinentry-tty
		iwd
		vlock
		(pass.withExtensions (exts: [ exts.pass-otp ]))
		pass
		zoxide
		zsh-syntax-highlighting
		python3
		pipx
		ranger
		stow
		trash-cli
		pciutils
		openssl
		qrencode
		oathToolkit
		rtorrent
		jq
		parted
		glxinfo
		zip
		unzip
		logrotate
		ntfy-sh
		pv
		pwgen
		nginx
		php
		sqlite
		file
		ncdu
		htop
	];
	
	# Allowing Unfree Packages
	nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [];

	services.logrotate.enable = true;

	services.ntfy-sh = {
		enable = true;
		settings = {
			base-url = "http://xansaware.ddns.net";
			listen-http = ":7778";
			auth-file = "/var/lib/ntfy-sh/user.db";
			auth-default-access = "read-write";
		};
	};

	services.nginx = {
		enable = true;
		virtualHosts = {
			"localhost".root = "/var/www";
		};
	};

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
	services.openssh = {
		enable = true;
		settings = {
			PasswordAuthentication = false;
			PermitRootLogin = "no";
			KbdInteractiveAuthentication = true;
			AuthenticationMethods = "publickey,keyboard-interactive:pam";
			ChallengeResponseAuthentication = true;
			UsePAM = true;
		};
		extraConfig = ''
			AllowTcpForwarding yes
		'';
	};

	# Open ports in the firewall.
	networking.firewall = {
		enable = true;
		allowedTCPPorts = [ 22 ];
	};

	# Enable routing
	boot.kernel.sysctl = {
		"net.ipv4.conf.all.forwarding" = lib.mkDefault true;
	        "net.ipv4.conf.default.forwarding" = lib.mkDefault true;
	};
	
	# Enable NAT
	networking.nat.enable = true;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.11"; # Did you read the comment?

}


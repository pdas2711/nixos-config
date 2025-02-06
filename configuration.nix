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
			efi.canTouchEfiVariables = true;
			# Use Grub for the bootloader.
			grub = {
				enable = true;
				efiSupport = true;
				device = "nodev";
			};
		};

		kernelParams = [ "ip=169.168.1.1::169.168.1.0:255.255.255.252::enp6s0:off" ];
		initrd = {
			systemd.users.root.shell = "/bin/cryptsetup-askpass";
			network = {
				enable = true;
				ssh = {
					shell = "/bin/cryptsetup-askpass";
					enable = true;
					port = 2222;
					authorizedKeys = [
						"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIHMTMLADSEtAhxuBzgzngIhx7LZfo5vfnTaPzyRhPBx root@xansaware"
						"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPbTg0cEmjqNJd9rh2eEL4v4WVdIhsWTq19glZ8AnspK root@xansawarejb"
					];
					hostKeys = [ "/etc/ssh/initrd/ssh_host_ed25519_key" ];
				};
			};
		};

		binfmt.emulatedSystems = [ "aarch64-linux" ];
	};

	networking = {
		hostName = "xansaware"; # Define your hostname.
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

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

	# Change Power Button behavior to Sleep on short-press
	services.logind.extraConfig = ''HandlePowerKey=suspend'';

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

	# Default shell for all users
	users.defaultUserShell = pkgs.zsh;

	# Define a user account. Don't forget to set a password with ‘passwd’.
	users.mutableUsers = true;
	users.users = {
		pdas2711 = {
			isNormalUser = true;
			extraGroups = [ "wheel" "libvirtd" ];
			createHome = true;
			packages = with pkgs; [];
		};
		git = {
			isNormalUser = true;
			createHome = true;
			home = "/srv/git";
			homeMode = "755";
		};
		guest = {
			isNormalUser = true;
			createHome = true;
		};
	};

	# Enable Flakes
	nix.settings.experimental-features = [ "nix-command" "flakes" ];

	# Enabling applications
	programs.firefox.enable = true;
	programs.zsh = {
		enable = true;
		syntaxHighlighting.enable = true;
	};

  # List packages installed in system profile. To search, run:
  # $ nix search wget
	environment.systemPackages = with pkgs; [
		flatpak
		neovim
		tmux
		wget
		alacritty
		zsh
		git
		pkgsUnstable.git-filter-repo
		gnupg
		pinentry-tty
		iwd
		hyprpaper
		hyprlock
		hyprshot
		waybar
		vlock
		wl-clipboard
		(pass.withExtensions (exts: [ exts.pass-otp ]))
		pass
		pavucontrol
		zoxide
		zsh-syntax-highlighting
		python3
		pipx
		ranger
		wlsunset
		stow
		trash-cli
		pciutils
		openssl
		qrencode
		oathToolkit
		libreoffice
		zathura
		mpv
		yt-dlp
		imv
		ffmpeg
		rtorrent
		openjdk
		jq
		gimp
		obs-studio
		parted
		bemenu
		glxinfo
		zip
		unzip
		radicale
		logrotate
		jellyfin
		jellyfin-web
		jellyfin-ffmpeg
		ntfy-sh
		zig
		pv
		pandoc
	];

	# Hyprland
	programs.hyprland = {
		enable = true;
		xwayland.enable = true;
	};

	# Enable Flatpak
	services.flatpak.enable = true;

	# Radicale
	services.radicale = {
		enable = true;
		settings = {
			server.hosts = [ "169.168.1.1:5232" "127.0.0.1:5232" ];
			auth = {
				type = "htpasswd";
				htpasswd_filename = "/var/lib/radicale/users";
				htpasswd_encryption = "bcrypt";
			};
			storage.filesystem_folder = "/var/lib/radicale/collections";
		};
	};

	services.logrotate.enable = true;
	services.jellyfin = {
		enable = true;
		openFirewall = true;
	};

	services.ntfy-sh = {
		enable = true;
		settings = {
			base-url = "http://xansaware.ddns.net";
			listen-http = ":7777";
			auth-file = "/var/lib/ntfy-sh/user.db";
			auth-default-access = "read-write";
		};
	};

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

	environment.etc.crypttab.text = ''backup_root	/dev/disk/by-uuid/823f75c2-3c8b-4ebd-b20c-3ac86de1028f	/var/lib/private/luks_keys/backup_drive.key
jellyfin	/dev/disk/by-uuid/9b514292-923a-4852-8556-2bb9c77346d9	/var/lib/private/luks_keys/jellyfin.key
backup_jellyfin	/dev/disk/by-uuid/d9fa1d9a-86dd-4d89-b9d5-9254f27b7186	/var/lib/private/luks_keys/jellyfin.key
	'';

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

	# OATH 2FA for SSH
	security.pam = {
		services.sshd = {
			oathAuth = true;
			setLoginUid = true;
			text = ''# Account management.
account required /nix/store/sl3fa5zh61xxl03m64if2wqzbvrb6zly-linux-pam-1.6.1/lib/security/pam_unix.so # unix (order 10900)

# Authentication management.
auth required /nix/store/0fri5mlc1zmf8lfiskvz0ramny51vaq6-oath-toolkit-2.6.12/lib/security/pam_oath.so digits=6 usersfile=/etc/users.oath window=30 # oath (order 11100)

# Password management.
password sufficient /nix/store/sl3fa5zh61xxl03m64if2wqzbvrb6zly-linux-pam-1.6.1/lib/security/pam_unix.so nullok yescrypt # unix (order 10200)

# Session management.
session required /nix/store/sl3fa5zh61xxl03m64if2wqzbvrb6zly-linux-pam-1.6.1/lib/security/pam_env.so conffile=/etc/pam/environment readenv=0 # env (order 10100)
session required /nix/store/sl3fa5zh61xxl03m64if2wqzbvrb6zly-linux-pam-1.6.1/lib/security/pam_unix.so # unix (order 10200)
session required /nix/store/sl3fa5zh61xxl03m64if2wqzbvrb6zly-linux-pam-1.6.1/lib/security/pam_loginuid.so # loginuid (order 10300)
session optional /nix/store/bl5dgjbbr9y4wpdw6k959mkq4ig0jwyg-systemd-256.10/lib/security/pam_systemd.so # systemd (order 12000)
session required /nix/store/sl3fa5zh61xxl03m64if2wqzbvrb6zly-linux-pam-1.6.1/lib/security/pam_limits.so conf=/nix/store/mibdlp1bmk4wl2qjk77i6fl1dg4kq6k6-limits.conf # limits (order 12200)
			'';
		};
		oath.window = 30;
	};

	# Sudoers
	security.sudo.extraRules = [
		{
			users = [ "ALL" ];
			commands = [ {
				command = "/home/git/add-user";
				options = [ "NOPASSWD" ];
			} ];
		}
	];

	# Open ports in the firewall.
	networking.firewall = {
		enable = true;
		allowedTCPPorts = [ 7777 9418 ];
		allowedUDPPorts = [ ];
	};

	# Virtualization/Hypervisor
	programs.virt-manager.enable = true;
	virtualisation.libvirtd.enable = true;
	virtualisation.spiceUSBRedirection.enable = true;

	systemd.services.git-daemon = {
		wantedBy = [ "multi-user.target" ];
		after = [ "network.target" ];
		description = "Local Git Server";
		serviceConfig = {
			ExecStart = ''${pkgs.git}/bin/git daemon --reuseaddr --base-path=/srv/git/users --export-all'';
			User = "git";
			Restart = "always";
		};
	};


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


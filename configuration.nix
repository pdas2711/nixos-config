# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, pkgsUnstable, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use Grub for the bootloader.
  	boot.loader = {
		efi.canTouchEfiVariables = true;
		grub = {
			enable = true;
			efiSupport = true;
			device = "nodev";
		};
	};

	boot.kernelParams = [ "ip=169.168.1.1::169.168.1.0:255.255.255.252::enp6s0:off" ];
	boot.initrd = {
		systemd.users.root.shell = "/bin/cryptsetup-askpass";
		network = {
			enable = true;
			ssh = {
				shell = "/bin/cryptsetup-askpass";
				enable = true;
				port = 23;
				authorizedKeys = [
					"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIHMTMLADSEtAhxuBzgzngIhx7LZfo5vfnTaPzyRhPBx root@xansaware"
				];
				hostKeys = [ "/etc/ssh/initrd/ssh_host_ed25519_key" ];
			};
		};
	};

  networking.hostName = "xansaware"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

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
  users.users.pdas2711 = {
    	isNormalUser = true;
    	extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
	createHome = true;
	packages = with pkgs; [];
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
		ranger
		wlsunset
		stow
		trash-cli
		pciutils
		openssl
		qrencode
		oathToolkit
	];

	# Hyprland
	programs.hyprland = {
		enable = true;
		xwayland.enable = true;
	};

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
	services.openssh = {
		enable = true;
		settings = {
			PasswordAuthentication = false;
			PermitRootLogin = "no";
		};
	};

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

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


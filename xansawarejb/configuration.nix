{ lib, pkgs, nixpkgs, ... }: {
	imports = [
		./hardware-configuration.nix
	];

	boot = {
		loader.grub.enable = false;  # Use the extlinux boot loader. (NixOS wants to enable GRUB by default)
		loader.generic-extlinux-compatible.enable = true;  # Enables the generation of /boot/extlinux/extlinux.conf
		initrd = {
			availableKernelModules = [
				"xhci_pci"
				"usbhid"
				"usb_storage"
				"vc4"
				"pcie_brcmstb"  # required for the pcie bus to work
				"reset-raspberrypi"  # required for vl805 firmware to load
			];
			kernelModules = [ ];
		};
		kernelModules = [ ];
		extraModulePackages = [ ];
		kernelParams = [ "snd_bcm2835.enable_hdmi=1" "snd_bcm2835.enable_headphones=1" ];
	};

	# networking config. important for ssh!
	networking = {
		hostName = "xansawarejb";
                networkmanager = {
                        enable = true;  # Easiest to use and most distros use this by default.
			wifi.powersave = false;
                };
	};
	
	# Set your time zone.
	time.timeZone = "America/New_York";

	# Select internationalisation properties.
	i18n.defaultLocale = "en_US.UTF-8";
	console = {
		enable = true;
		font = "Lat2-Terminus16";
		keyMap = "us";
	};

	# The default shell for all users
	users.defaultUserShell = pkgs.zsh;

	# User account definitions
	users.mutableUsers = true;
	users.groups.wake.members = [ "pdas2711" ];
	users.users.pdas2711 = {
		initialHashedPassword = "$6$f/je.OPO7cENlXH1$ISqeSsCLjN2EM0TdE9ruws6ZSJcKnhVrKxKVo6tn9ixOGk.glfmiZQaOJVx8/xAcgzm6nbyqFL72ZmUbFS89L.";  # Password is 'password' for initial SSH login. Change this immediately!
		isNormalUser = true;
		extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
		createHome = true;
		openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDHDR1GQu+7CyqqzIFXHbeAExNxxkbhQuWJoeYLNsK55lXb0Eci7HQZphwLS9al6kdxy08mJD5xJe1PCZJmXWyqiuQGpQtvIpqO/S7nrPOhpxzD7aB0BZP5XYleDaOBsIch+JGk25C/HqJsOXGpxet80jpklTpMWJ0M+xfVfnUlVEa7HXsmLNB/CNTiSNuDYTjuzjdjgwdJaBocaycdMwEHU+8yqU3C3gVNqjd37EHskpfTLsp10HtrnvbTf064LXVskrB8IHNVF8o80NnGidzLEftCCfnfDbByDvC+fET6vDq0J5WR4glP8MZutOEVSBXaBI813GNj2U8K+Ap+qeQDv4+1FqIH1OedRXaNUgziOzb7YG+nlXmQRYYBo+88qazhw2pV2VoGIzpjCfwQBEi5dERw3eFwuFHIzTe9DeDijTCYjLYn2W3/KEz8RQpCR1mIILlqBcAdAkNMLDll2RFLcoKOsnNDY///ZKtsl0AqaJpjR/33kfhFGu4aRTGxeXa/7q+Vkm7pRTFIK3KR6YJtowlSaVNttJh0wDvw3rH77JV1apu81VD5WF1kqVk9i/OSPzE1WQU3LlN/Xrw59p7Mhx4b1A0BAxUyQRbcYGa0J3oZL7Q+CoA9Pkpn0BRAbppRK61TtaPP7oV8YwBBzoliWB5/X7xWFTJeSAPojSDBLQ== openpgp:0xCF57ED6B" ];
	};

	# Enable the OpenSSH daemon.
	services.openssh = {
		enable = true;
		ports = [ 23 ];
		settings = {
			PasswordAuthentication = false;
			PermitRootLogin = lib.mkDefault "no";
			AuthenticationMethods = "publickey";
		};
		sftpServerExecutable = "internal-sftp";
		extraConfig = ''Include sshd_config.d/*
AllowTcpForwarding yes'';
	};

	# Sudoers
	security.sudo = {
		enable = true;
		extraRules = [
			{
				groups = [ "wake" ];
				commands = [ {
					command = "/run/current-system/sw/bin/wake";
					options = [ "NOPASSWD" ];
				} ];
			}
		];
	};

	# Installing Packages
	environment.systemPackages = with pkgs; [
		libraspberrypi
		raspberrypi-eeprom
		fastfetch
		tmux
		neovim
		vlock
		wget
		iwd
		git
		ranger
		stow
		openssl
		parted
		trash-cli
		gnupg
		pinentry-tty
		zsh-syntax-highlighting
		zoxide
		zsh
		veracrypt
		wol
		nmap
		jq
		(import ./wake.nix { inherit pkgs; })
	];

	# Allowing Unfree Packages
	nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
             "veracrypt"
        ];

	# allows the use of flakes
	nix.settings = {
		keep-outputs = true;
		keep-derivations = true;
		experimental-features = [ "nix-command" "flakes" ];
	};

	programs.zsh = {
		enable = true;
		syntaxHighlighting.enable = true;
	};
	environment.variables = {
		SHELL = "zsh";
		EDITOR = "neovim";
	};

	# State Version. Don't change this!
	system.stateVersion = "24.11";
}

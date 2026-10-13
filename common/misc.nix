{ pkgs, ... }: {
	# Default user configuration
	users.defaultUserShell = pkgs.zsh;  # Default shell for all users
	users.mutableUsers = true;  # Allows creating users outside of NixOS configuration
	
	# Set your time zone
	time.timeZone = "America/New_York";

	# Select internationalisation properties
	i18n.defaultLocale = "en_US.UTF-8";
	console = {
		font = "Lat2-Terminus16";
		keyMap = "us";
	};

	# Enable sound
	services.pipewire = {
		enable = true;
		pulse.enable = true;
	};
	
	# Nix settings
	nix = {
		settings.experimental-features = [ "nix-command" "flakes" ];
		gc.automatic = true;
		gc.options = "--delete-older-than 15d";
	};

	# Nix Remote Deployer
	users.users.nixos = {
		isNormalUser = true;
	};

	security.sudo.extraRules = [
		{
			users = [ "nixos" ];
			commands = [
				{ command = "ALL"; options = [ "NOPASSWD" ]; }
			];
		}
	];

	nix.settings.trusted-users = [ "nixos" ];
	
	# /etc config files
	environment.etc = {
		environment.text = ''export EDITOR=nvim
		'';
	};

	# Environment variables
	environment.variables = {
		SUDO_EDITOR = "nvim";  # Default editor when using sudo
	};

	# Enable sudo
	security.sudo.enable = true;
	
	# Logrotate
	services.logrotate.enable = true;

	# Enable Polkit
	security.polkit.enable = true;

	# Enable mounting USB devices
	services.udisks2.enable = true;

	# Remove emergency shell so the user isn't waiting indefinitely during the boot process
	systemd.enableEmergencyMode = false;

	# Use kmscon for the TTY terminal instead of the built-in kernel VT
	services.kmscon = {
		enable = true;
		hwRender = true;
		extraConfig = ''
font-size=24

palette=custom
palette-black=69,71,90
palette-red=243,139,168
palette-green=166,227,161
palette-yellow=249,226,175
palette-blue=137,180,250
palette-magenta=245,194,231
palette-cyan=148,226,213
palette-dark-grey=88,91,112
palette-light-red=235,160,172
palette-light-green=166,227,161
palette-light-yellow=250,179,135
palette-light-blue=116,199,236
palette-light-magenta=242,205,205
palette-light-cyan=137,220,235
palette-light-grey=166,173,200
palette-white=205,214,244
palette-foreground=205,214,244
palette-background=30,30,46
'';
		fonts = [
			{
				name = "JetBrainsMono Nerd Font Mono";
				package = pkgs.nerd-fonts.jetbrains-mono;
			}
		];
	};
}

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
	
	# /etc config files
	environment.etc = {
		environment.text = ''export EDITOR=nvim
		'';
	};

	# Environment variables
	environment.variables = {
		SUDO_EDITOR = "nvim";  # Default editor when using sudo
	};
}

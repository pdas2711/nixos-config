{ pkgs, ... }: {
	# Group creation for power-timer
	users.groups.power-timer = {};

	# Sudoers rule to run without a password for power-timer group
	security.sudo.extraRules = [
		{
			groups = [ "power-timer" ];
			commands = [ {
				command = "/run/current-system/sw/bin/power-timer";
				options = [ "NOPASSWD" ];
			} ];
		}
	];

	# Add power-timer to environment packages
	environment.systemPackages = [ (import ./power_timer_sh.nix { inherit pkgs; }) ];
}

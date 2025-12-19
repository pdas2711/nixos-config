{ pkgs, ... }: {
	# Group creation for wake
	users.groups.wake = {};

	# Sudoers rule to run wake script without password for wake group
	security.sudo.extraRules = [
		{
			groups = [ "wake" ];
			commands = [ {
				command = "/run/current-system/sw/bin/wake";
				options = [ "NOPASSWD" ];
			} ];
		}
	];

	# Add wake to environment packages
	environment.systemPackages = [ (import ./wake.nix { inherit pkgs; }) ];
}

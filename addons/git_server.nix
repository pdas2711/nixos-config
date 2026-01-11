{ pkgs, ... }: {
	# Git User
	users.users.git = {
		isNormalUser = true;
		createHome = true;
		home = "/srv/git";
		homeMode = "755";
		shell = "${pkgs.git}/bin/git-shell";
	};

	# Git Server using Git Daemon
	systemd.services = {
		git-daemon = {  # Git Server
			wantedBy = [ "multi-user.target" ];
			after = [ "network.target" ];
			description = "Local Git Server";
			serviceConfig = {
				ExecStart = ''${pkgs.git}/bin/git daemon --reuseaddr --base-path=/srv/git/users --export-all'';
				User = "git";
				Restart = "always";
			};
		};
	};
	
	# Sudoers rule for adding repositories to git
	security.sudo.extraRules = [
		{
			users = [ "ALL" ];
			commands = [ {
				command = "/run/current-system/sw/bin/add-git-user";
				options = [ "NOPASSWD" ];
			} ];
		}
	];

	# Add add-git-user script to environment packages
	environment.systemPackages = [ (import ./add_git_user_sh.nix { inherit pkgs; }) ];
}

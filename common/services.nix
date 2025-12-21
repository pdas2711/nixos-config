{ ... }: {
	# Logrotate
	services.logrotate.enable = true;
	
	# Fail2Ban
	services.fail2ban = {
		enable = true;
		maxretry = 5;
		ignoreIP = [
			"10.100.0.0/24" "192.168.1.0/24"  # Whitelisted devices on the Wireguard VPN or local home network
		];
		bantime = "4h"; # Ban IPs for the given time on the first ban
		bantime-increment = {
			enable = true;  # Enable increment of bantime after each violation
			multipliers = "1 2 4 8 16 32 64";
			maxtime = "168h";  # Do not ban for more than 1 week
			overalljails = true;  # Calculate the bantime based on all the violations
		};
	};
	
	# Enable the OpenSSH daemon.
	services.openssh = {
		enable = true;
		settings = {
			PasswordAuthentication = false;
			PermitRootLogin = "no";
			AuthenticationMethods = "publickey";
		};
		sftpServerExecutable = "internal-sftp";
		extraConfig = ''
			AllowTcpForwarding yes
		'';
	};
}

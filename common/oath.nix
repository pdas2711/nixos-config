{ ... }: {
	# OATH 2FA for SSH
	security.pam = {
		services.sshd = {
			oathAuth = true;
			setLoginUid = true;
			text = ''# Account management.
account required ${pkgs.linux-pam}/lib/security/pam_unix.so # unix (order 10900)

# Authentication management.
auth [success=done default=ignore] ${pkgs.linux-pam}/lib/security/pam_succeed_if.so user ingroup ignoreoath  # Ignore OATH for users in this group
auth required ${pkgs.oathToolkit}/lib/security/pam_oath.so digits=6 usersfile=/etc/users.oath window=30 # oath (order 11100)

# Password management.
password sufficient ${pkgs.linux-pam}/lib/security/pam_unix.so nullok yescrypt # unix (order 10200)

# Session management.
session required ${pkgs.linux-pam}/lib/security/pam_env.so conffile=/etc/pam/environment readenv=0 # env (order 10100)
session required ${pkgs.linux-pam}/lib/security/pam_unix.so # unix (order 10200)
session required ${pkgs.linux-pam}/lib/security/pam_loginuid.so # loginuid (order 10300)
session optional ${pkgs.systemd}/lib/security/pam_systemd.so # systemd (order 12000)
session required ${pkgs.linux-pam}/lib/security/pam_limits.so conf=${pkgs.linux-pam}/etc/security/limits.conf # limits (order 12200)
			'';
		};
		oath.window = 30;
	};
}

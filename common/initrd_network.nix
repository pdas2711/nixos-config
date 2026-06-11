{ ... }: {
	# Enable networking in initrd when unlocking LUKS root
	boot.initrd = {
		network = {
			enable = true;
			ssh = {
				enable = true;
				port = 2222;
				authorizedKeys = [
					"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIHMTMLADSEtAhxuBzgzngIhx7LZfo5vfnTaPzyRhPBx root@xansaware"
					"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPbTg0cEmjqNJd9rh2eEL4v4WVdIhsWTq19glZ8AnspK root@xansawarejb"
				];
				hostKeys = [ "/etc/ssh/initrd/ssh_host_ed25519_key" ];
			};
		};
		systemd.services.initrd-ssh-unlock = {
			description = "Enable automatic unlocking of LUKS via SSH";
			wantedBy = [ "initrd.target" ];
			before = [ "initrd-root-fs.target" ];
			unitConfig.DefaultDependencies = false;
			script = ''
				mkdir -p /var/empty
				echo "exec systemd-tty-ask-password-agent --watch" > /var/empty/.profile
				chmod 755 /var/empty/.profile
			'';
			serviceConfig.Type = "oneshot";
		};
	};
}

{ ... }: {
	# Enable networking in initrd when unlocking LUKS root
	boot.initrd = {
		network = {
			enable = true;
			ssh = {
				enable = true;
				port = 2222;
				authorizedKeys = [
					"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIHMTMLADSEtAhxuBzgzngIhx7LZfo5vfnTaPzyRhPBx root@xansaware command=\"systemctl default\""
					"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPbTg0cEmjqNJd9rh2eEL4v4WVdIhsWTq19glZ8AnspK root@xansawarejb command=\"systemctl default\""
				];
				hostKeys = [ "/etc/ssh/initrd/ssh_host_ed25519_key" ];
			};
		};
	};
}

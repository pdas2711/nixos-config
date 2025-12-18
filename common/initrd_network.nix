{ ... }: {
	# Enable networking in initrd when unlocking LUKS root
	boot.initrd = {
		network = {
			enable = true;
			ssh = {
				shell = "/bin/cryptsetup-askpass";
				enable = true;
				port = 2222;
				authorizedKeys = [
					"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIHMTMLADSEtAhxuBzgzngIhx7LZfo5vfnTaPzyRhPBx root@xansaware"
					"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPbTg0cEmjqNJd9rh2eEL4v4WVdIhsWTq19glZ8AnspK root@xansawarejb"
				];
				hostKeys = [ "/etc/ssh/initrd/ssh_host_ed25519_key" ];
			};
		};
	};
}

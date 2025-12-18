# Passphrase prompt for systems that root filesystems LUKS-encrypted
{ ... }: {
	boot.initrd.systemd.users.root.shell = "/bin/cryptsetup-askpass";
}

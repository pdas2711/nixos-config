{ ... }: {
	# KVM/QEMU and Libvirt
	programs.virt-manager.enable = true;
	virtualisation.libvirtd.enable = true;
	virtualisation.spiceUSBRedirection.enable = true;
	networking.firewall.trustedInterfaces = [ "virbr0" ];
}

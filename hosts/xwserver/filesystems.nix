{ ... }: {
	# Import root filesystem layout
	imports = [ ../../common/default_mounts.nix ];
	
	# LUKS root device target
	boot.initrd.luks.devices."root".device = "/dev/disk/by-uuid/3553337a-b7b9-4b97-b72f-03bc8d660820";

	# Filesystem for boot device
	fileSystems."/boot" = {
		device = "/dev/disk/by-uuid/F17D-09B2";
		fsType = "vfat";
		options = [ "fmask=0022" "dmask=0022" ];
	};

	# Device target for root filesystem
	fileSystems = {
		"/".device = "/dev/disk/by-uuid/83903e6b-e486-4510-9e84-91db757e4ad0";
		"/var".device = "/dev/disk/by-uuid/83903e6b-e486-4510-9e84-91db757e4ad0";
		"/home".device = "/dev/disk/by-uuid/83903e6b-e486-4510-9e84-91db757e4ad0";
	};
}

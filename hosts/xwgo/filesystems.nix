{ ... }: {
	# Import basic filesystem layout
	imports = [ ../../common/default_mounts.nix ];

	# LUKS root device target
	boot.initrd.luks.devices."root".device = "/dev/disk/by-uuid/adde90b1-12c2-4d2d-ba77-c36bb83ce50f";

	# Filesystem for boot device
	fileSystems."/boot" = {
		device = "/dev/disk/by-uuid/A85E-E5AF";
		fsType = "vfat";
		options = [ "fmask=0022" "dmask=0022" ];
	};

	# Device target for root filesystem
	fileSystems = {
		"/".device = "/dev/disk/by-uuid/52cf6217-82b9-43e2-bbc2-81b69c466c97";
		"/var".device = "/dev/disk/by-uuid/52cf6217-82b9-43e2-bbc2-81b69c466c97";
		"/home".device = "/dev/disk/by-uuid/52cf6217-82b9-43e2-bbc2-81b69c466c97";
	};
}

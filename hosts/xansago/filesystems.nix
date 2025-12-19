{ ... }: {
	# Import basic filesystem layout
	imports = [ ../../common/default_mounts.nix ];

	# LUKS root device target
	boot.initrd.luks.devices."root".device = "adde90b1-12c2-4d2d-ba77-c36bb83ce50f";

	# Filesystem for boot device
	filesystems."/boot" = {
		device = "A85E-E5AF";
		fsType = "vfat";
		options = [ "fmask=0022" "dmask=0022" ];
	};

	# Device target for root filesystem
	let
		root_target = "/dev/disk/by-uuid/52cf6217-82b9-43e2-bbc2-81b69c466c97";
	in {
		fileSystems = {
			"/".device = root_target;
			"/var".device = root_target;
			"/home".device = root_target;
		};
	};
}

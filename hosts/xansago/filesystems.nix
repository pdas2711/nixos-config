{ ... }: {
	# Import basic filesystem layout
	let
		common_dir = ../../common;
	in
		imports = [ common_dir + ./default_mounts.nix ];

	# LUKS root device target
	boot.initrd.luks.devices."root".device = "";

	# Filesystem for boot device
	filesystems."/boot" = {
		device = "";
		fsType = "vfat";
		options = [ "fmask=0022" "dmask=0022" ];
	};

	# Device target for root filesystem
	let
		root_target = "/dev/disk/by-uuid/UUID";
	in {
		fileSystems = {
			"/".device = root_target;
			"/var".device = root_target;
			"/home".device = root_target;
		};
	};
}

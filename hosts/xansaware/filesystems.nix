{ ... }: {
	# Import root filesystem layout
	imports = [ ../../common/default_mounts.nix ];

	# LUKS root device target
	boot.initrd.luks.devices."root".device = "/dev/disk/by-uuid/b26194e7-6e22-42f6-9fc2-3aa9f5974331";

	# Filesystem for boot device
	fileSystems."/boot" = {
		device = "/dev/disk/by-uuid/42D7-221F";
		fsType = "vfat";
		options = [ "fmask=0022" "dmask=0022" ];
	};

	# Device target for root filesystem
	fileSystems = {
		"/".device = "/dev/disk/by-uuid/0357a60d-827b-4b6c-9290-7b974dd61b7f";
		"/var".device = "/dev/disk/by-uuid/0357a60d-827b-4b6c-9290-7b974dd61b7f";
		"/home".device = "/dev/disk/by-uuid/0357a60d-827b-4b6c-9290-7b974dd61b7f";
	};
	
	# Backup Root Drive
	fileSystems."/mnt/backup_root" = {
		device = "/dev/mapper/backup_root";
		fsType = "btrfs";
	};

	# Jellyfin Media Drive
	fileSystems."/mnt/jellyfin-media" = {
		device = "/dev/mapper/jellyfin";
		fsType = "btrfs";
		options = [ "subvol=@" ];
	};
	
	# Backup Jellyfin Media Drive
	fileSystems."/mnt/backup_jellyfin" = {
		device = "/dev/mapper/backup_jellyfin";
		fsType = "btrfs";
	};
	
	# Steam Expansion Drive
	fileSystems."/mnt/games" = {
		device = "/dev/disk/by-uuid/b1fd16ee-a131-4c14-bf98-660fa5924edf";
		fsType = "btrfs";
		options = [ "subvol=@" ];
	};
}

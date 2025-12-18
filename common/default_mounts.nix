# Basic layout of the root partition using BTRFS subvolumes
{ ... }: {
	fileSystems = {
		"/" = {
			fsType = "btrfs";
			options = [ "subvol=@" ];
		};
		"/var" = {
			fsType = "btrfs";
			options = [ "subvol=@var" ];
		};
		"/home" = {
			fsType = "btrfs";
			options = [ "subvol=@home" ];
		};
	};
}

{ lib, ... }: {
	boot = {
		loader = {
			efi.canTouchEfiVariables = if (boot.loader.grub.efiInstallAsRemovable == false) then true else false;
			# Use Grub for the bootloader.
			grub = {
				enable = true;
				efiSupport = true;
				device = "nodev";
			};
		};
	};
}

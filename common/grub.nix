{ lib, config, ... }: {
	boot = {
		loader = {
			# This is relevant if the UEFI on the host is doesn't recognize custom EFI names
			efi.canTouchEfiVariables = if (config.boot.loader.grub.efiInstallAsRemovable == false) then true else false;
			# Use Grub for the bootloader.
			grub = {
				enable = true;
				efiSupport = true;
				device = "nodev";
			};
		};
	};
}

{ ... }: {
	boot = {
		loader = {
			efi.canTouchEfiVariables = true;
			# Use Grub for the bootloader.
			grub = {
				enable = true;
				efiSupport = true;
				device = "nodev";
			};
		};
	};
}

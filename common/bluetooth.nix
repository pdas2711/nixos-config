{ ... }: {
	# Enable Bluetooth controller
	hardware = {
		bluetooth.enable = true;
		bluetooth.powerOnBoot = true;
	};

	# Enable Blueman service
	services.blueman.enable = true;
}

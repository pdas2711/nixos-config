{ ... }: {
	# Allow iwd to be the backend for WiFi
	networking = {
		wireless.iwd.enable = true;  # Enables wireless support via iwd.
		networkmanager.wifi.backend = "iwd";
		interfaces.wlan0.useDHCP = lib.mkDefault true;
	};
}

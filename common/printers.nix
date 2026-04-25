{ pkgs, ... }: {
	# Enable auto discovery of printers using the IPP Everywhere/Airprint protocol
	services.avahi = {
		enable = true;
		nssmdns4 = true;
		openFirewall = true;
	};
	services.printing = {
		enable = true;
		drivers = with pkgs; [
			cups-filters
			cups-browsed
		];
	};

	# Enable Airscan support for scanner backend
	hardware.sane.extraBackends = [
		pkgs.sane-airscan
		pkgs.hplipWithPlugin  # HP Officejet 5740 e-AIO uses proprietary HP plugin. This printer also supports Airscan for scanning.
	];
	services.udev.packages = [ pkgs.sane-airscan ];
}

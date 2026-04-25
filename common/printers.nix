{ config, pkgs, lib, ... }: {
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
	hardware.sane = {
		enable = true;
		extraBackends = [
			pkgs.sane-airscan
			pkgs.hplipWithPlugin  # HP Officejet 5740 e-AIO uses proprietary HP plugin. This printer also supports Airscan for scanning.
		];
	};
	
	# Disable detecting the webcam as a scanner
	hardware.sane.disabledDefaultBackends = [ "v4l" ];

	services.udev.packages = [ pkgs.sane-airscan ];
}

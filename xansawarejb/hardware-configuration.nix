{ config, lib, pkgs, modulesPath, ... }: {
	imports = [
		(modulesPath + "/installer/scan/not-detected.nix")
	];

	hardware = {
		raspberry-pi."4" = {
			#fkms-3d.enable = true;
			#audio.enable = true;
			apply-overlays-dtmerge.enable = true;
		};
		deviceTree = {
			enable = true;
			filter = "bcm2711-rpi-4*.dtb";
		};
	};

	fileSystems."/" = {
		device = "/dev/disk/by-label/NIXOS_SD";
		fsType = "ext4";
		options = [ "noatime" ];
	};

	swapDevices = [ ];

	networking.interfaces.eth0 = {
		useDHCP = false;
		ipv4.addresses = [ {
                        address = "169.168.1.2";
                        prefixLength = 30;
                } ];
	};
	networking.interfaces.wlan0.useDHCP = lib.mkDefault true;
	networking.networkmanager.unmanaged = [ "interface-name:eth0" ];

	# Bluetooth
	hardware.bluetooth.enable = true; # enables support for Bluetooth
	hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
	services.blueman.enable = true;

	nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
}

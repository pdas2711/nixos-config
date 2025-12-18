{ modulesPath, ... }: {
	imports = [
		(modulesPath + "/installer/scan/not-detected.nix")
	];

	# Kernel Modules
	boot.initrd.availableKernelModules = [ "nvme" "ahci" "usb_storage" "usbhid" ];
	boot.kernelModules = [ "kvm-intel" ];

	# Nixpkg platform target
	nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
	
	# CPU microcode
	hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}

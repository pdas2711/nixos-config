{ config, lib, modulesPath, ... }: {
	imports = [
		(modulesPath + "/installer/scan/not-detected.nix")
	];

	# Kernel Modules
	  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usb_storage" "sd_mod" "rtsx_usb_sdmmc" ];
	boot.kernelModules = [ "kvm-intel" ];

	# Nixpkg platform target
	nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
	
	# CPU microcode
	hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}

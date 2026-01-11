{ config, lib, modulesPath, ... }: {
	imports = [
		(modulesPath + "/installer/scan/not-detected.nix")
	];

	# Kernel Modules
	boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" "igb" ];
	boot.initrd.kernelModules = [ "igb" ];
	boot.kernelModules = [ "kvm-amd" ];

	# Nixpkg platform target
	nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
	
	# CPU microcode
	hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}

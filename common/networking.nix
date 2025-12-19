{ lib, ... }: {
	# NetworkManager
	networking.networkmanager.enable = true;

	# Enable routing
	boot.kernel.sysctl = {
		"net.ipv4.conf.all.forwarding" = lib.mkDefault true;
	        "net.ipv4.conf.default.forwarding" = lib.mkDefault true;
	};
	
	# Enable NAT
	networking.nat.enable = true;

	# Enable NFTables
	networking.nftables.enable = true;
}

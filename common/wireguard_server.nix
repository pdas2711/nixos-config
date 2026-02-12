{ ... }: {
	# Wireguard Setup
	networking.wireguard.enable = true;
	networking.nat.internalInterfaces = [ "wg0" ];
	networking.wg-quick.interfaces.wg0.configFile = "/etc/wireguard/wg0.conf";

	# Open Firewall
	networking.firewall.allowedUDPPorts = [ 51820 ];
}

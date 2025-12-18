{ ... }: {
	# Wireguard Setup
	networking.nat.externalInterface = "enp5s0";
	networking.nat.internalInterfaces = [ "wg0" ];
	networking.wireguard.enable = true;
	networking.wg-quick.interfaces.wg0.configFile = "/etc/wireguard/wg0.conf";
}

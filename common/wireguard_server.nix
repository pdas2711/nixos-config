{ ... }: {
	# Import firewall routing rule for wireguard
	imports = [ ./wireguard_init.nix ];

	# Wireguard Server Setup
	networking.wireguard.enable = true;
	networking.wg-quick.interfaces.wg0.configFile = "/etc/wireguard/wg0.conf";

	# Open Firewall
	networking.firewall.allowedUDPPorts = [ 51820 ];
}

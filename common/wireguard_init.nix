{ ... }: {
	# Firewall routing for both Wireguard Client and Server
	# Import this file when Wireguard is being used as a client
	# Use wireguard_server.nix for using Wireguard as a server and it will automatically import this file
	networking.nat.internalInterfaces = [ "wg0" ];
}

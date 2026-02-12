# Wireguard configuration for client
{ pkgs, ... }: {
	# Firewall routing for both Wireguard Client and Server
	# Import this file when Wireguard is being used as a client
	networking.nat.internalInterfaces = [ "wg0" ];

	# Install Wireguard as a package when server configuration is not used
	environment.systemPackages = with pkgs; [ wireguard-tools ];
}

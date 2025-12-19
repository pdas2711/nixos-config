{ pkgs, ... }: {
	# Hyprland
	programs.hyprland = {
		enable = true;
		xwayland.enable = true;
		withUWSM = true;
	};
	
	# UWSM
	programs.uwsm.waylandCompositors = {
		hyprland = {
			prettyName = "Hyprland";
			binPath = "/run/current-system/sw/bin/Hyprland";
		};
	};
	
	# GUI Applications
	environment.systemPackages = with pkgs; [
		alacritty
		zathura
		libreoffice
		bemenu
		brave
		hyprpaper
		hyprlock
		hyprshot
		waybar
		wl-clipboard
		wlsunset
		pavucontrol
	];
	
	# Enable Flatpak
	services.flatpak.enable = true;
}

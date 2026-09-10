{ inputs, pkgs, ... }: {
	# Hyprland
	programs.hyprland = {
		enable = true;
		xwayland.enable = true;
		withUWSM = true;
	};

	# Niri
	programs.niri.enable = true;

	# XDG Portal
	xdg.portal = {
		enable = true;
		extraPortals = [
			pkgs.xdg-desktop-portal-hyprland
			pkgs.xdg-desktop-portal-gtk
		];
		xdgOpenUsePortal = true;
		wlr.enable = false;
	};
	
	# UWSM
	programs.uwsm = {
		enable = true;
		waylandCompositors = {
			hyprland = {
				prettyName = "Hyprland";
				binPath = "/run/current-system/sw/bin/Hyprland";
			};
		};
	};
	
	# GUI Applications
	environment.systemPackages = with pkgs; [
		alacritty
		kitty
		zathura
		imv
		libreoffice
		xournalpp
		bemenu
		brave
		hyprpaper
		hyprlock
		hyprshot
		hyprshell
		waybar
		wl-clipboard
		wlsunset
		pavucontrol
		thunderbird
		xwayland-satellite  # For niri
		swaybg
		swaylock
	];
	
	# Enable Flatpak
	services.flatpak.enable = true;
}

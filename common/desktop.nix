{ inputs, pkgs, ... }: {
	# Hyprland
	imports = [ inputs.hyprland.nixosModules.default ];
	programs.hyprland = {
		enable = true;
		xwayland.enable = true;
		withUWSM = true;
		plugins = [
			inputs.hyprland_scroll_overview.packages.${pkgs.system}.default
		];
	};

	# XDG Portal
	xdg.portal = {
		enable = true;
		extraPortals = [
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
	];
	
	# Enable Flatpak
	services.flatpak.enable = true;
}

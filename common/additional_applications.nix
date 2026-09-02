# Optional Additional Applications that extends the base

{ pkgs, pkgsUnstable, ... }: {
	environment.systemPackages = with pkgs; [
		python3
		yazi
		ffmpeg
		mpv
		qrencode
		oath-toolkit
		pwgen
		rtorrent
		libcaca
		libsixel
		cowsay
		jq
		gopass
		nb
		mdbook
		newsboat
		img2pdf
		tabiew
		typst
		fzf
		wtfutil
	];
	
	# Enables NBD Kernel Module
	programs.nbd.enable = true;

	# Xonsh Shell
	programs.xonsh.enable = true;
}

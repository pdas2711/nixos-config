# Optional Additional Applications that extends the base

{ pkgs, pkgsUnstable, ... }: {
	environment.systemPackages = with pkgs; [
		python3
		ranger
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
	];
	
	# Enables NBD Kernel Module
	programs.nbd.enable = true;
}

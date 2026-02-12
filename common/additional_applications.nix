# Optional Additional Applications that extends the base

{ pkgs, pkgsUnstable, ... }: {
	environment.systemPackages = with pkgs; [
		python3
		pipx
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
	];
	
	# Enables NBD Kernel Module
	programs.nbd.enable = true;
}

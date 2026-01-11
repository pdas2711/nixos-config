# Optional Additional Applications that extends the base

{ pkgs, pkgsUnstable, ... }: {
	environment.systemPackages = with pkgs; [
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
		nbd
	];
}

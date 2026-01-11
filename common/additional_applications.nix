# Optional Additional Applications that extends the base

{ pkgs, pkgsUnstable, ... }: {
	environment.systemPackages = with pkgs; [
		ffmpeg
		mpv
		qrencode
		oathToolkit
		pwgen
		rtorrent
		libcaca
		libsixel
		cowsay
		jq
	];
}

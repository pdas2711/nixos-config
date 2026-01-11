# Common applications

{ pkgs, pkgsUnstable, ... }: {
	environment.systemPackages = with pkgs; [
		fastfetch
		tmux
		wget
		git-filter-repo
		gnupg
		pinentry-tty
		vlock
		gopass
		zoxide
		zsh-syntax-highlighting
		python3
		pipx
		ranger
		stow
		trash-cli
		pciutils
		openssl
		qrencode
		oathToolkit
		mpv
		rtorrent
		jq
		parted
		zip
		unzip
		logrotate
		pv
		pwgen
		file
		ncdu
		htop
		libcaca
		libsixel
		cargo
		rustc
		gcc
		nbd
		elinks
		cowsay
		newsboat
	];

	# Zsh
	programs.zsh = {
		enable = true;
		syntaxHighlighting.enable = true;
	};
	
	# Git Config
	programs.git = {
		enable = true;
		config.init.defaultBranch = "main";
	};
	
	# Neovim
	programs.neovim = {
		enable = true;
		defaultEditor = true;
	};
}

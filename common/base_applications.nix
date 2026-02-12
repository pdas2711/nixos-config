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
		stow
		trash-cli
		pciutils
		openssl
		parted
		zip
		unzip
		pv
		file
		ncdu
		htop
		cargo
		rustc
		gcc
		nbd
		elinks
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

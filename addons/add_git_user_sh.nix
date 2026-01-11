{ pkgs, ... }:
	pkgs.writeShellScriptBin "power-timer" ''
if [[ ''${EUID} -ne 0 ]]; then
	echo "You must run with 'sudo'."
	exit
fi

if [[ ! -d ~git/"users/''${SUDO_USER}" ]]; then
        mkdir -p ~git/users/''${SUDO_USER}
        chown ''${SUDO_USER}:users ~git/users/''${SUDO_USER}
        setfacl -d -m u:''${SUDO_USER}:rwX,g:users:rX,o::rX ~git/users/''${SUDO_USER}
	exit
else
        echo "User repo is already added."
        exit
fi
''

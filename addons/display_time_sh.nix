{ pkgs, ... }:
        pkgs.writeShellScriptBin "display-time" ''
function show_date() {
	while true; do
		date +%H:%M:%S
		sleep 1
	done
}

PIDFILE="$XDG_RUNTIME_DIR/display-time.pid"

if [[ -s "''${PIDFILE}" ]] && kill -0 "$(cat "''${PIDFILE}")" 2>/dev/null; then
	kill "$(cat "''${PIDFILE}")"
	rm -f "''${PIDFILE}"
else
	rm -f "''${PIDFILE}"
	show_date | ${pkgs.proycon-wayout}/bin/proycon-wayout --layer overlay --position top --font "Monospace 40" --feed-line &
	echo "$!" > "''${PIDFILE}"
fi
''

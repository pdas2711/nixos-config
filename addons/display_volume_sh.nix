{ pkgs, ... }:
        pkgs.writeShellScriptBin "display-volume" ''
function display() {
	if wpctl get-volume ''${1} | grep -q 'MUTED'; then
		echo 0 > $XDG_RUNTIME_DIR/volume.wob
	else
		wpctl get-volume ''${1} | sed 's/[^0-9]//g' > $XDG_RUNTIME_DIR/volume.wob
	fi
}

function set_volume() {
	if [[ "''${2}" == "increment" ]]; then
		wpctl set-volume ''${1} 0.05+ -l 1.0
	elif [[ "''${2}" == "decrement" ]]; then
		wpctl set-volume ''${1} 0.05-
	elif [[ "''${2}" == "mute" ]]; then
		wpctl set-mute ''${1} toggle
	else
		echo "Incorrect argument."
	fi
}

# Create Pipe for Wob
if [[ ! -p $XDG_RUNTIME_DIR/volume.wob ]]; then
	mkfifo $XDG_RUNTIME_DIR/volume.wob
fi

# Arguments
if [[ "''${1}" == "out" ]]; then
	pipe_id="@DEFAULT_AUDIO_SINK@"
	set_volume ''${pipe_id} ''${2}
	display ''${pipe_id}
elif [[ "''${1}" == "in" ]]; then
	pipe_id="@DEFAULT_AUDIO_SOURCE@"
	set_volume ''${pipe_id} ''${2}
	display ''${pipe_id}
else
	echo "Incorrect argument."
fi
''

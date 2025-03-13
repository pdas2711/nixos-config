{ pkgs }:
	pkgs.writeShellScriptBin "start-hyprland" ''
${pkgs.dbus}/bin/dbus-launch --exit-with-session ${pkgs.hyprland}/bin/Hyprland
''

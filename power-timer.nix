{ pkgs }:
	pkgs.writeShellScriptBin "power-timer" ''
if [[ ''${EUID} -ne 0 ]]; then
	echo "Please run as root."
	exit
fi

config_dir="/home/''${SUDO_USER}/.config/power-timer/config.json"
username=$(${pkgs.jq}/bin/jq .username "''${config_dir}" | sed 's/"//g')
password=$(${pkgs.jq}/bin/jq .password "''${config_dir}" | sed 's/"//g')
server=$(${pkgs.jq}/bin/jq .server "''${config_dir}" | sed 's/"//g')

if [[ "''${1}" != "poweroff" ]] && [[ "''${1}" != "suspend" ]]; then
	echo "Unknown argument."
	exit
fi

if [[ -z "''${2}" ]]; then
	echo "Enter the number of minutes for the timer to start before the machine powers off."
	read -p "Amount: " timermin
else
	timermin="''${2}"
fi

if [[ ''${timermin} -le 5 ]]; then
	echo "Cannot be 5 minutes or less."
	exit
fi

sleeptime=$((''${timermin} - 5))

echo "Current time: $(date +"%T")"
echo "Timer started."
${pkgs.coreutils}/bin/sleep ''${sleeptime}m

${pkgs.curl}/bin/curl -u ''${username}:''${password} -d "5 minutes remaining before machine powers off." "''${server}"
${pkgs.coreutils}/bin/sleep 5m

if [[ "''${1}" == "poweroff" ]]; then
	systemctl poweroff
elif [[ "''${1}" == "suspend" ]]; then
	systemctl suspend
fi
''

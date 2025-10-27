{ pkgs }:
	pkgs.writeShellScriptBin "power-timer" ''
if [[ ''${EUID} -ne 0 ]]; then
	echo "Please run as root."
	exit
fi

for (( i=1; i<="$#"; i++ )); do
	if [[ "''${!i}" == "--no-notifications" ]]; then
		allow_notif="false"
	elif [[ -z "''${poweropt}" ]]; then
		poweropt="''${!i}"
	else
		timermin="''${!i}"
	fi
done

if [[ "''${allow_notif}" != "false" ]]; then
	if [[ ! -f "/home/''${SUDO_USER}/.config/power-timer/config.json" ]]; then
		echo "'~/.config/power-timer/config.json' not found. Pass '--no-notifications' as an argument to omit the notification functionality."
		exit
	fi
	config_dir="/home/''${SUDO_USER}/.config/power-timer/config.json"
	username=$(${pkgs.jq}/bin/jq .username "''${config_dir}" | sed 's/"//g')
	password=$(${pkgs.jq}/bin/jq .password "''${config_dir}" | sed 's/"//g')
	server=$(${pkgs.jq}/bin/jq .server "''${config_dir}" | sed 's/"//g')
fi

if [[ -z "''${poweropt}" ]]; then
	echo
	echo "1. Suspend"
	echo "2. Poweroff"
	echo
	read -p "Choose power option: " poweropt
	if [[ "''${poweropt}" == "1" ]]; then
		poweropt="suspend"
	elif [[ "''${poweropt}" == "2" ]]; then
		poweropt="poweroff"
	else
		echo "Incorrect option."
		exit
	fi
elif [[ "''${poweropt}" != "poweroff" ]] && [[ "''${poweropt}" != "suspend" ]]; then
	echo "Unknown argument ''${poweropt}."
	exit
fi

if [[ -z "''${timermin}" ]]; then
	echo "Enter the number of minutes for the timer to start before the machine powers off."
	read -p "Amount: " timermin
else
	timermin="''${timermin}"
fi

if [[ ''${timermin} -le 5 ]]; then
	echo "Cannot be 5 minutes or less."
	exit
fi

sleeptime=$((''${timermin} - 5))

echo "Current time: $(date +"%T")"
echo "Timer started."
${pkgs.coreutils}/bin/sleep ''${sleeptime}m

if [[ "''${allow_notif}" != "false" ]]; then
	${pkgs.curl}/bin/curl -u ''${username}:''${password} -d "5 minutes remaining before the system powers off." "''${server}"
fi
echo "5 minutes remaining before the system powers off."
${pkgs.coreutils}/bin/sleep 5m

if [[ "$(who | grep -v "''${SUDO_USER}")" != "" ]]; then
	echo "Other users are logged in. Aborting."
else
	if [[ "''${poweropt}" == "poweroff" ]]; then
		systemctl poweroff
	elif [[ "''${poweropt}" == "suspend" ]]; then
		systemctl suspend
	fi
fi
''

{ pkgs, ... }:
        pkgs.writeShellScriptBin "wake" ''
if [[ ''${EUID} -ne 0 ]]; then
        echo "Root privileges required."
        exit
fi

if [[ ! -d "/srv/secrets/luks" ]]; then
	echo "LUKS key not found. Terminating."
	exit
fi

ip_address=$(${pkgs.jq}/bin/jq .ip_address /etc/wake_config.json | sed 's/"//g')
port=$(${pkgs.jq}/bin/jq .port /etc/wake_config.json)
initrd_ip_address=$(${pkgs.jq}/bin/jq .initrd_ip_address /etc/wake_config.json | sed 's/"//g')
initrd_port=$(${pkgs.jq}/bin/jq .initrd_port /etc/wake_config.json)
mac=$(${pkgs.jq}/bin/jq .mac /etc/wake_config.json | sed 's/"//g')
broadcast_ip=$(${pkgs.jq}/bin/jq .broadcast_ip /etc/wake_config.json | sed 's/"//g')

${pkgs.wol}/bin/wol --ipaddr ''${broadcast_ip} ''${mac}

echo "Waiting for the system at ''${ip_address} to fully boot..."
while true; do
        if [[ $(${pkgs.nmap}/bin/nmap -p ''${port} ''${ip_address} | grep "''${port}/tcp" | awk '{print $2}') == "open" ]]; then
                echo "Done!"
                exit
        elif [[ $(${pkgs.nmap}/bin/nmap -p ''${initrd_port} ''${initrd_ip_address} | grep "''${initrd_port}/tcp" | awk '{print $2}') == "open" ]]; then
                echo "The OS is partially booted. Unlocking..."
                cat /srv/secrets/luks/luks.key | ${pkgs.openssh}/bin/ssh -p ''${initrd_port} -o IdentitiesOnly=yes -i ~/.ssh/init root@''${initrd_ip_address}
        else
                sleep 5s
        fi
done
''

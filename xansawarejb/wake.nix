{ pkgs }:
        pkgs.writeShellScriptBin "wake" ''
hostname=$(${pkgs.jq}/bin/jq .hostname /etc/wake_config.json | sed 's/"//g')
port=$(${pkgs.jq}/bin/jq .port /etc/wake_config.json)
initrd_hostname=$(${pkgs.jq}/bin/jq .initrd_hostname /etc/wake_config.json | sed 's/"//g')
initrd_port=$(${pkgs.jq}/bin/jq .initrd_port /etc/wake_config.json)
mac=$(${pkgs.jq}/bin/jq .mac /etc/wake_config.json | sed 's/"//g')

${pkgs.wol}/bin/wol --ipaddr ''${hostname} ''${mac}

echo "Waiting for the machine to fully boot..."
while true; do
        if [[ $(${pkgs.nmap}/bin/nmap -p ''${port} ''${hostname} | grep "''${port}/tcp" | awk '{print $2}') == "open" ]]; then
                echo "Done!"
                exit
        elif [[ $(${pkgs.nmap}/bin/nmap -p ''${initrd_port} ''${initrd_hostname} | grep "''${initrd_port}/tcp" | awk '{print $2}') == "open" ]]; then
                echo "The OS is partially booted. Unlocking..."
                cat /srv/secrets/luks/luks.key | ${pkgs.openssh}/bin/ssh -p ''${initrd_port} root@''${initrd_hostname}
        else
                sleep 5s
        fi
done
''

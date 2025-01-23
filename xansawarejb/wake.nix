with import <nixpkgs> {};
writeShellScriptBin "wake" ''
#!/usr/bin/env bash

hostname=$(jq .hostname /etc/wake_config.json)
port=$(jq .port /etc/wake_config.json)
initrd_hostname=$(jq .initrd_hostname /etc/wake_config.json)
initrd_port=$(jq .initrd_port /etc/wake_config.json)
mac=$(jq .mac /etc/wake_config.json)

wol --ipaddr ${hostname} ${mac}

echo "Waiting for the machine to fully boot..."
while true; do
        if [[ $(nmap -p ${port} ${hostname} | grep "${port}/tcp" | awk '{print $2}') == "open" ]]; then
                echo "Done!"
                exit
        elif [[ $(nmap -p ${initrd_port} ${initrd_hostname} | grep "${initrd_port}/tcp" | awk '{print $2}') == "open" ]]; then
                echo "The OS is partially booted. Unlocking..."
                cat /srv/secrets/luks/luks.key | ssh -p ${initrd_port} root@${initrd_hostname}
        else
                sleep 5s
        fi
done
''

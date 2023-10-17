#!/bin/bash

cat << EOF >> /etc/sysctl.conf
net.ipv4.ip_forward=1
EOF

sysctl -p

cat << EOF > /etc/nftables.conf
#!/usr/sbin/nft -f

flush ruleset

table inet filter {
        chain input {
                type filter hook input priority 0;
        }
        chain forward {
                type filter hook forward priority 0;
        }
        chain output {
                type filter hook output priority 0;
        }
}

table inet nat {
	chain postrouting {
                type nat hook postrouting priority 0;
		oifname ens4 masquerade
	}
}
EOF

systemctl disable ufw.service
systemctl stop ufw.service
systemctl enable --now nftables.service


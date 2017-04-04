iptables --flush
iptables --table nat --flush
iptables --table nat --delete-chain

iptables --table nat --append POSTROUTING --out-interface wlan0 -j MASQUERADE
iptables --append FORWARD --in-interface eth0 -j ACCEPT

echo 1 > /proc/sys/net/ipv4/ip_forward

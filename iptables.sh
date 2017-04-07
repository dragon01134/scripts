#Change below out interface
OUT_IFACE=wlan0

#Change below in interfaces
IN_IFACE=eth0

#flusing all iptables
iptables --flush
iptables --table nat --flush
iptables --table nat --delete-chain

iptables --table nat --append POSTROUTING --out-interface $OUT_IFACE -j MASQUERADE
iptables --append FORWARD --in-interface $IN_IFACE -j ACCEPT

echo 1 > /proc/sys/net/ipv4/ip_forward

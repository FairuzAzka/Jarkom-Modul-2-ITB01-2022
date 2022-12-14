echo "nameserver 192.168.122.1" > /etc/resolv.conf
apt-get update

# nomor 5
apt-get update  
apt-get install bind9 -y
echo '
zone "wise.itb01.com" {
        type slave;
        masters { 10.45.2.2; }; // Masukan IP Wise tanpa tanda petik
        file "/var/lib/bind/wise.itb01.com";
};
' > /etc/bind/named.conf.local

service bind9 restart

# nomor 6
echo "
options {
        directory \"/var/cache/bind\";
        allow-query{any;};
        auth-nxdomain no;    # conform to RFC1035
        listen-on-v6 { any; };
};
" > /etc/bind/named.conf.options

echo '
zone "wise.itb01.com" {
        type slave;
        masters { 10.45.2.2; }; // Masukan IP Wise tanpa tanda petik
        file "/var/lib/bind/wise.itb01.com";
};

zone "operation.wise.itb01.com"{
        type master;
        file "/etc/bind/operation/operation.wise.itb01.com";
};
'> /etc/bind/named.conf.local

mkdir /etc/bind/operation

echo '
$TTL    604800
@       IN      SOA     operation.wise.itb01.com. root.operation.wise.itb01.com. (
                        20221025      ; Serial
                        604800        ; Refresh
                        86400         ; Retry
                        2419200       ; Expire
                        604800 )      ; Negative Cache TTL
;
@               IN      NS      operation.wise.itb01.com.
@               IN      A       10.45.3.3 ;IP Eden
www             IN      CNAME   operation.wise.itb01.com.
' > /etc/bind/operation/operation.wise.itb01.com

service bind9 restart

# nomor 7
echo '
$TTL    604800
@       IN      SOA     operation.wise.itb01.com. root.operation.wise.itb01.com. (
                        20221025      ; Serial
                        604800        ; Refresh
                        86400         ; Retry
                        2419200       ; Expire
                        604800 )      ; Negative Cache TTL
;
@               IN      NS      operation.wise.itb01.com.
@               IN      A       10.45.3.3  ;IP Eden
www             IN      CNAME   operation.wise.itb01.com.
strix           IN      A       10.45.3.3  ;IP Eden
www.strix       IN      CNAME   operation.wise.itb01.com.
' > /etc/bind/operation/operation.wise.itb01.com

service bind9 restart
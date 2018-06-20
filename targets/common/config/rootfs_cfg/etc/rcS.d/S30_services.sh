#! /bin/sh

echo Starting Network Services...

inetd
/sbin/sshd
#smbd

#/sbin/dhcpd -cf /etc/dhcpd.conf
#ntpdate  ntp.univ-lyon1.fr canon.inria.fr ntp1.tuxfamily.net

#httpd -h /home/www

lighttpd -f /etc/lighttpd/lighttpd.conf

vsftpd &

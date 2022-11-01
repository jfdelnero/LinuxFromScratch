#  /bin/sh

export adr_to_test=8.8.8.8

echo w > /dev/watchdog

test=`ping -c 1 $adr_to_test | grep " 0%"`

if [ -z "$test"  ]; then

	NB=`cat /var/log/reconnect`
	NB=`expr $NB + 1`
	echo $NB >/var/log/reconnect

	NB2=`cat /var/log/reconnect2`
	NB2=`expr $NB2 + 1`
	echo $NB2 >/var/log/reconnect2

	if [ $NB2 -gt 120  ]; then
		reboot
	fi

	if [ $NB2 -gt 2  ]; then

	fi

else
	echo "0" >/var/log/reconnect2
fi


#!/bin/bash

/media/cryptofs/apps/usr/palm/services/com.palmdts.devmode.service/volume.sh 2>&1 &

# Reset devmode reboot counter
rm -f /var/luna/preferences/dc*
echo '9000:00:00' > /media/cryptofs/apps/usr/palm/services/com.palmdts.devmode.service/devSessionTime
chgrp 5000 /media/cryptofs/apps/usr/palm/services/com.palmdts.devmode.service/devSessionTime
chmod 664 /media/cryptofs/apps/usr/palm/services/com.palmdts.devmode.service/devSessionTime

#Auto start plex when TV starts
luna-send -n 1 -f luna://com.webos.applicationManager/launch '{"id": "cdp-30", "params":{}}'

# Start root telnet server
telnetd -l /bin/sh

# give the system time to wake up
sleep 5

# PoC notification
#luna-send -f -n 1 luna://com.webos.notification/createToast '{"message": "Hello! I am running as: '"$(id)"'"}'

# Do our best to neuter telemetry
mkdir -p /home/root/unwritable
chattr +i /home/root/unwritable
mount --bind /home/root/unwritable/ /var/spool/rdxd/
mount --bind /home/root/unwritable/ /var/spool/uploadd/pending/
mount --bind /home/root/unwritable/ /var/spool/uploadd/uploaded/

#for sshd and nfs mount
mkdir /media/cryptofs/root
mkdir /media/cryptofs/root/etc
mkdir /media/cryptofs/root/bin
mkdir /media/cryptofs/root/lib
mkdir /media/cryptofs/root/sbin
mkdir -p -m0755 /var/run/sshd
cp -r /etc/* /media/cryptofs/root/etc/
cp -r /bin/* /media/cryptofs/root/bin/    
cp -r /lib/* /media/cryptofs/root/lib/    
cp -r /sbin/* /media/cryptofs/root/sbin/    
mount --bind /media/cryptofs/root/etc /etc
mount --bind /media/cryptofs/root/bin /bin
mount --bind /media/cryptofs/root/lib /lib
mount --bind /media/cryptofs/root/sbin /sbin
ln -s /media/cryptofs/apps/usr/palm/services/com.palmdts.devmode.service/binaries-armv71/opt/openssh/etc/* /etc/
ln -s /media/cryptofs/apps/usr/palm/services/com.palmdts.devmode.service/binaries-armv71/opt/openssh/etc/init.d/* /etc/
ln -s /media/cryptofs/apps/usr/palm/services/com.palmdts.devmode.service/binaries-armv71/opt/openssh/lib/openssh/systemd/system /lib/lib/systemd/system
ln -s /media/cryptofs/apps/usr/palm/services/com.palmdts.devmode.service/binaries-armv71/opt/openssh/bin/* /bin/
ln -s /media/cryptofs/apps/usr/palm/services/com.palmdts.devmode.service/binaries-armv71/opt/openssh/lib/openssh/* /lib/
ln -s /media/cryptofs/apps/usr/palm/services/com.palmdts.devmode.service/binaries-armv71/opt/openssh/sbin/* /sbin/

#for nano
ln -s /bin/rnano /bin/nano

#to block update
echo "127.0.0.1 snu.lge.com" >> /media/cryptofs/root/etc/hosts
echo "127.0.0.1 fi.lgtvsdp.com" >> /media/cryptofs/root/etc/hosts
echo "127.0.0.1 us.lgtvsdp.com" >> /media/cryptofs/root/etc/hosts
echo "127.0.0.1 in.lgtvsdp.com" >> /media/cryptofs/root/etc/hosts
echo "127.0.0.1 fr.lgtvsdp.com" >> /media/cryptofs/root/etc/hosts


#start sshd
echo -e "YourPassword\nYourPassword" | (passwd root)
/sbin/sshd -f /etc/ssh/sshd_config

#mounting nfs
/sbin/rpc.statd --no-notify -n LGwebOSTV
mount.nfs4 -o intr,soft,udp,nolock yourserver:/share /tmp/usb/sda/sda1/yoursharelocal

sleep 300

#stop telnetd
pkill telnetd

#backup
cp /media/cryptofs/apps/usr/palm/services/com.palmdts.devmode.service/*.sh /tmp/usb/sda/sda1/yoursharelocal

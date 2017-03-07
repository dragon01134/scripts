#!/bin/bash
abc=`grep "alias uxtreme" ~/.bashrc`
if [ $? -gt 0 ]
then
echo "alias uxtreme='rw;mv -f /var/log/updates/xtremed /usr/sbin/xtremed ;cleanlogs ;sre'" >>~/.bashrc
fi

abc=`grep "alias ulxtreme" ~/.bashrc`
if [ $? -gt 0 ]
then
echo "alias ulxtreme='rw;mv -f /var/log/updates/xtremed /usr/sbin/xtremed ;sre'" >>~/.bashrc
fi

abc=`grep "alias ufatpipe" ~/.bashrc`
if [ $? -gt 0 ]
then
echo "alias ufatpipe=\"rw; mv -f /var/log/updates/fatpipe.ko /lib/modules/\`uname -r\`/kernel/net/ipv4/fatpipe.ko ; cleanlogs;sre\"" >>~/.bashrc
echo "alias ulfatpipe=\"rw; mv -f /var/log/updates/fatpipe.ko /lib/modules/\`uname -r\`/kernel/net/ipv4/fatpipe.ko ;sre\"" >>~/.bashrc
fi

abc=`grep "alias ulfatpipe" ~/.bashrc`
if [ $? -gt 0 ]
then
echo "alias ulfatpipe=\"rw; mv -f /var/log/updates/fatpipe.ko /lib/modules/\`uname -r\`/kernel/net/ipv4/fatpipe.ko ;sre\"" >>~/.bashrc
fi

abc=`grep "alias clean_keys" ~/.bashrc`
if [ $? -gt 0 ]
then
echo "alias clean_keys=\"cat /dev/null >/home/`whoami`/.ssh/known_hosts\"" >>~/.bashrc
fi

. ~/.bashrc

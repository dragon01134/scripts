#!/bin/bash
#Description: This script will install twiki 6 with minimum user interaction in CENTOS 07.
#	      User interaction needed when installing perl module and adding superuser password.
#	      I tried minimizing as much possible user interaction.
#Author: Jitendra
#Date: 03 Oct 2017

#updating yum(not required always)
yum -y update

#Installing required packages
yum install -y wget perl unzip rcs gcc make gd gd-devel php

#Installing apache server
yum install httpd

#Adding firewall bypass command for port 80 and 443 
firewall-cmd --permanent --add-port=80/tcp
firewall-cmd --permanent --add-port=443/tcp
#Reload firewall
firewall-cmd --reload

#Disabling SELINUX(Permanent)
sed -i 's/^SELINUX.*/SELINUX=disabled/g' /etc/selinux/config 
#Disabling SELINUX(Temp.)
setenforce 0

#Starting httpd
systemctl start httpd

#Apache starts at boot
systemctl enable httpd


#Installing some perl-module
yum install -y perl-CPAN perl-ExtUtils-CBuilder perl-YAML perl-Module-CoreList perl-CGI perl-Module-Build perl-IPC-Cmd

#Installing some perl module using cpan

clear

#Enabling all yes and default for installing perl module
export PERL_MM_USE_DEFAULT=1
export PERL_EXTUTILS_AUTOINSTALL="--defaultdeps"

echo "Installing some perl module using cpan"

module_list="Term::ReadKey Bundle::CPAN Cwd LWP CGI::Carp Encode HTML::Parser Error Time::Local Text::Diff Authen::SASL CGI::Session Digest::SHA1 URI Locale::Maketext::Lexicon FreezeThaw GD HTML::Tree Time::Timezone"

for module in $module_list
do
 	echo "$module installing.."
	cpan $module
done

#Removing CGI Module for less that 4.03 CGI Module
cpan App::cpanminus
cpanm --uninstall CGI



#Installing CGI module less that 4.04
wget -c http://www.cpan.org/authors/id/S/SH/SHERZODR/CGI-Session-4.03.tar.gz
tar -xvf CGI-Session-4.03.tar.gz
cd CGI-Session-4.03
perl Makefile.PL
make
make test
make install
cd 

echo "Module installation Done"

#Installing twiki
wget http://downloads.sourceforge.net/project/twiki/TWiki%20for%20all%20Platforms/TWiki-6.0.1/TWiki-6.0.1.zip
mkdir  /var/www/html/twiki
unzip TWiki-6.0.1.zip -d /var/www/html/twiki
chown -R apache:apache /var/www/html/twiki
cd /var/www/html/twiki
mv bin/LocalLib.cfg.txt bin/LocalLib.cfg

sed -i 's:$twikiLibPath = \".*\":$twikiLibPath =\"/var/www/html/twiki/lib\":g' bin/LocalLib.cfg

cp misc/twiki_httpd_conf.txt /etc/httpd/conf.d/twiki.conf

sed -i 's_/home/httpd_/var/www/html_g' /etc/httpd/conf.d/twiki.conf
sed -i "s/AuthName.*/AuthName \'root\'/g"  /etc/httpd/conf.d/twiki.conf

cd data/
htpasswd -c .htpasswd root
cd

systemctl restart httpd


#!/usr/bin/perl
use strict;
use warnings;

print"Please insert the host name: \n";

my $name = <STDIN>;
chomp($name);

my $USER ='$USER';

my $conf =qq(
<VirtualHost *:80>
    ServerAdmin admin\@test.com
    ServerName www.$name.com
    ServerAlias $name.com
    DocumentRoot /var/www/$name/
    ErrorLog \${APACHE_LOG_DIR}/error.log
    CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
);  

my $conf_name ="/etc/apache2/sites-available/$name.conf";   

my $index = "/var/www/$name/index.html";

print"Start work!!!\n"; 

`mkdir -p /var/www/$name/`;

open(FH, '>', $index) or die $!;

print FH "<h1>This is $name </h1>"; 

close FH;

`sudo chown -R $USER:$USER /var/www/$name`;

`sudo chmod -R 755 /var/www/$name`;

open(FH, '>', $conf_name) or die $!;

print FH $conf; 

close FH;

`sudo a2dissite 000-default.conf`;

`sudo a2ensite $name.conf`;

`apachectl restart`; 

print"Apache Virtual host was created!!! \n Please insert in ~/hosts the following: 'i.p.address www.\$name.com'\n";

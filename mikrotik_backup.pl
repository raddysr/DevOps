#!/usr/bin/perl 

use strict;
use Net::OpenSSH;

my @opt = ({object=>'test1',username=>'admin', password => 'killer86', ip=>'192.168.88.117'}, 
	{object=>'test2', username=>'admin', password=>'1234', ip=>'192.168.88.115'} ); 

my $backup_name = "backup$$"; 

############################### COMMANDS #######################################

my $RSC_EXPORT = "/export file=$backup_name";
my $BACKUP = "/system backup save name=$backup_name";
my $INFO = '/system resource print';
my $ROUTING ='/ip route print';
my $IP_ADDRESS = '/ip address print'; 
my $INTERFACE = '/interface print'; 
my $FIRMWARE ='/system routerboard print';
my $HOSTNAME  ='/system identity print'; 
#my $SYSTEM_UPGRADE  ='/system routerboard upgrade'; 
my $SSHPASS = '/usr/bin/sshpass';
my $SCP = '/usr/bin/scp';

################################ WORK #########################################

print"Begin|".scalar localtime."|"."\n"; 

foreach my $obj (@opt) {
	
	my $ip=$obj->{ip};
		 
	my $backup_dir = "/home/projects/mikrotik_task/tmp/$obj->{object}_$$/"; 

	`mkdir -p $backup_dir`; 

	my $ssh = Net::OpenSSH->new("$obj->{username}\@$ip",timeout => 30, password=>$obj->{password});

	$ssh->error and die "Unable to connect: " + $ssh->error;

	$ssh->system($RSC_EXPORT);
	
	`$SSHPASS -p $obj->{password} $SCP $obj->{username}\@$ip:/$backup_name.rsc $backup_dir`; 

	$ssh->system($BACKUP); 
	
	`$SSHPASS -p $obj->{password} $SCP $obj->{username}\@$ip:/$backup_name.backup $backup_dir`; 

	#$ssh->system($SYSTEM_UPGRADE); 
		
	my $hostname  = $ssh->pipe_out($HOSTNAME) or die $!;
	
	while(<$hostname>){
		
		$hostname = $_; 

	}
	chomp($hostname);
	
	$hostname =~ s/name://; 
	
	$hostname =~ s/\s+|\t+//;
	
	$hostname =~ s/\r//;
	
	$hostname =~ s/$//; 
	
	open(FH, '>', $backup_dir.$hostname ."_$$.txt"); 
	
	print "Connected to $ip\n";
		
	my $info = $ssh->pipe_out($INFO) or die "Unable to run command";
 	
	while (<$info>) {
   		
 		print FH $_;
		
	}
 		
	$info= $ssh->pipe_out($ROUTING) or die $!;

	while (<$info>){
	
		print FH $_; 
	
	}

	$info = $ssh->pipe_out($IP_ADDRESS) or die $!;

	while (<$info>){
	
		print FH $_; 
	
	}

	$info = $ssh->pipe_out($INTERFACE) or die $!;

	while (<$info>){
	
		print FH $_; 
	
	}

	$info = $ssh->pipe_out($FIRMWARE) or die $!;

	while (<$info>){
	
		print FH $_; 
	
	}

	close FH;
	
	close $info;

	undef $ssh;	

}

print"Complete|".scalar localtime."|"."\n"; 

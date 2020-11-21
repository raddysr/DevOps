#!/usr/bin/perl
use strict;
use warnings;

my $signal	= shift;
my $start	= "/home/hadoop/hadoop-3.3.0/sbin/start-dfs.sh";
my $start_yarn	= "/home/hadoop/hadoop-3.3.0/sbin/start-yarn.sh";
my $stop 	= "/home/hadoop/hadoop-3.3.0/sbin/stop-dfs.sh";
my $stop_yarn	= "/home/hadoop/hadoop-3.3.0/sbin/stop-yarn.sh";

if($signal eq 'start'){
	print qx/$start/;	
	print qx/$start_yarn/;

}elsif( $signal eq 'stop'){
	print qx/$stop/;
	print qx/$stop_yarn/; 
}else{
	print"Run script with start or stop argumet";
}


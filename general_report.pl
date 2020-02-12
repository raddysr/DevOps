#!/usr/local/bin/perl -wT

use strict;
use warnings; 

my $REPORTS_DIRECTORY = '/tmp/cron_services_list/'; 
my $GENERAL_REPORTS_DIRECTORY = "/tmp/cron_general/";

my %scripts_hash = summary(); 

foreach my $script (keys %scripts_hash){
	
	chomp $script;	
	
	if($script eq '' ){
	
		next; 
	
	}
	
	if( -f $script){
	
		open (FH,'>>',$GENERAL_REPORTS_DIRECTORY."general_report_$$.txt") or die $!;
	
		print FH $script."\n";
	
	}else{

		open (FH,'>>',$GENERAL_REPORTS_DIRECTORY."ne_general_report_$$.txt") or die $!;

		print FH $script."\n"; 

	}
	
	close FH;

}

print STDERR '[' . scalar (localtime) . ']' . " REPORT FINISHED!\n"; 

sub summary {

	my %scripts_hash = ();
	
	opendir my $dh, $REPORTS_DIRECTORY  or die $!;

	my @reports = readdir $dh;

	foreach my $report (@reports){

		if($report eq '.' or $report eq '..'){
	
		next; 
	
		}
	
		open(FH,'<',$REPORTS_DIRECTORY.$report ) or die $!;

		while (my $script = <FH>){

			$scripts_hash{$script} = $script; 
	
		}

		close FH; 

	}
	return %scripts_hash; 

}

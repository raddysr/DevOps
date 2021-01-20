#!/usr/local/bin/perl -wT

use strict;
use warnings;

$ENV{PATH} = "";
$ENV{ENV} = "";

my $DEBUG_PARAM  = $$;
my $BASE_PATH	 = "/tmp/cron_services_list/";
my $HOSTNAME_CMD = "/bin/hostname";
my $FIND_CMD	 = "/usr/bin/find";
my $CRONTAB_CMD  = "/usr/bin/crontab";
my $XARGS_CMD	 = "/usr/bin/xargs";
my $GREP_CMD	 = "/usr/bin/grep";

my %uniq_files = ();
	
print_debug( { MSG => "$0 STARTED\n"});

print_debug( { MSG => "SCAN SERVICES exec\n"});
scan_services({ UNIQ_FILES_REF => \%uniq_files });
print_debug( { MSG => "SCAN SERVICES finish\n"});

print_debug( { MSG => "SCAN CRONTAB exec\n"});
scan_crontab({ UNIQ_FILES_REF => \%uniq_files }); 
print_debug( { MSG => "SCAN CRONTAB finish\n"});

print_debug( { MSG => "SCAN GEN_REPORT exec\n"});
generate_report({ UNIQ_FILES_REF => \%uniq_files , DEBUG_PARAM => $DEBUG_PARAM}) ;
print_debug( { MSG => "SCAN GEN_REPORT finish\n"});


print_debug( { MSG => ""});
print_debug( { MSG => ""});
print_debug( { MSG => ""});

sub scan_services {

	my $params = shift ;
	
	my $uniq_files = $params->{UNIQ_FILES_REF} ;

	my @service_run_files = `$FIND_CMD /var/services/ -type f -name  "run" -maxdepth 2 | $XARGS_CMD $GREP_CMD ".pl"` ;

	foreach my $filename ( @service_run_files ){
	
		if($filename=~ /^\#/){
			next; 
		}
		
		$filename =~ s/[\n\r]//g;
		my @filename_parts = split( /:/ , $filename);
		$filename = $filename_parts[1];
		$filename =~ s/\/usr\/home\//\/home\//; 
		$uniq_files->{$filename} = $filename;
	}
	return 1;
}

sub scan_crontab { 

	my $params = shift;

	my $uniq_files = $params->{UNIQ_FILES_REF} ;

	my @crontab=`$CRONTAB_CMD -l`;

	foreach(@crontab){
	
		if($_=~ /^\#/){
			next;
		}
        	
		my($con1, $cron2, $cron3, $cron4, $cron5, $script, $arguments)  =split/\t|\s+/,$_;
		$script =~ s/\/usr\/home\//\/home\//; 	
		$uniq_files->{$script} = $script ;
		
	}

	return 1; 
}

sub generate_report {
	
	my $params = shift;
	my $uniq_files = $params->{UNIQ_FILES_REF} ;
	my($sec, $min, $hour, $mday,$mon,$year,$wday,$yday,$idst)=localtime();

	my $hostname = `$HOSTNAME_CMD`;
	
	$hostname =~ s/\n//;
	$hostname =~ /(^[\w\.\+\_\-]+$)/;
	$hostname = $1;

	my $report = $hostname.'_'.$params->{DEBUG_PARAM}.'_'. $mday.$mon.$year.'.txt';

	open(FILE,'>', $BASE_PATH.$report) or die "I can't open it!\n";

	foreach my $uniq_filename ( keys %{$uniq_files} ){

		print FILE $uniq_filename."\n";
	}

	print_debug( { MSG => "Report complete!\n"});
	close FILE;

	return 1;
}

sub print_debug {

	my $params = shift;

	$params->{MSG} =~ s/[\r\n]$//g;

	print STDERR '[' . scalar (localtime).']: '." $params->{MSG}\n";
}

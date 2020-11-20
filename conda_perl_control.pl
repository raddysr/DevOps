#!/usr/bin/perl
use strict;
use warnings;

my $param = shift; 
chomp($param); 

if( ( !$param ) or ( $param ne '-s' ) or ( $param ne '-r' ) ){
	print"Run with parameter -s or -r!\n"; 
	exit; 
}

if($param eq '-s'){
	qx/conda config --set auto_activate_base false/;
	print"Anaconda stopped!\n"; 
}elsif($param eq '-r'){
	qx/conda config --set auto_activate_base true/;
	print"Anaconda is now running!\n"; 
}

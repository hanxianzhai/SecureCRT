#!/usr/bin/perl 
#===============================================================================
#
#         FILE: securecrt_linux_crack.pl
#
#        USAGE: ./securecrt_linux_crack.pl  
#
#  DESCRIPTION: securecrt_linux_crack
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: hanxianzhai
# ORGANIZATION: 
#      VERSION: 1.1
#      CREATED: 03-14-2014 18:00:00 
#     REVISION: ---
#===============================================================================

use strict;
use warnings;


sub license {
	print "\n".
	"License:\n\n".
	"\tName:\t\thanxianzhai\n".
	"\tCompany:\t0000000\n".
	"\tSerial Number:\t03-07-263942\n".
	"\tLicense Key:\tACEGXS AKPES6 YDN5VT 8MX9M3 AD6Z6B ZKA8M3 BM12FA 2FRSRB\n".
	"\tIssue Date:\t03-14-2014\n\n\n";
}

sub usage {
    print "\n".
	"help:\n\n".
	"\tperl securecrt_linux_crack.pl <file>\n\n\n".
	"\tperl securecrt_linux_crack.pl /usr/bin/SecureCRT\n\n\n".
    "\n";
	
	&license;

    exit;
}
&usage() if ! defined $ARGV[0] ;


my $file = $ARGV[0];

open FP, $file or die "can not open file $!";
binmode FP;

open TMPFP, '>', '/tmp/.securecrt.tmp' or die "can not open file $!";

my $buffer;
my $unpack_data;
my $crack = 0;

while(read(FP, $buffer, 1024)) {
	$unpack_data = unpack('H*', $buffer);
	if ($unpack_data =~ m/785782391ad0b9169f17415dd35f002790175204e3aa65ea10cff20818/) {
		$crack = 1;
		last;
	}
	if ($unpack_data =~ s/6e533e406a45f0b6372f3ea10717000c7120127cd915cef8ed1a3f2c5b/785782391ad0b9169f17415dd35f002790175204e3aa65ea10cff20818/ ){
		$buffer = pack('H*', $unpack_data);
		$crack = 2;
	}
	syswrite(TMPFP, $buffer, length($buffer));
}

close(FP);
close(TMPFP);

if ($crack == 1) {
		unlink '/tmp/.securecrt.tmp' or die "can not delete files $!";
		print "It has been cracked\n";
		&license;
		exit 1;
} elsif ($crack == 2) {
		rename '/tmp/.securecrt.tmp', $file or die 'Insufficient privileges, please switch the root account.';
		chmod 0755, $file or die 'Insufficient privileges, please switch the root account.';
		print "crack successful\n";
		&license;
} else {
	die 'error';
}

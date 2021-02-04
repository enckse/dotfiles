#!/usr/bin/perl
use strict;
use warnings;

my $pass_home   = $ENV{"PASSWORD_STORE_DIR"};
my $pass_offset = "keys/totp";
my $pass_dir    = "$pass_home/$pass_offset";

die "no command given" if not @ARGV;

my $cmd = shift @ARGV;

if ( $cmd eq "list" ) {
    for (
`find $pass_dir -type f -name "*.gpg" -exec basename {} \\; | sed "s/\\.gpg//g" | sort`
      )
    {
        chomp;
        print $_, " ";
    }
    exit;
}

die "unknown token $cmd" if system("test -e $pass_dir/$cmd.gpg") != 0;

$SIG{'INT'} = sub { exit; };

my $count = 0;
my $last  = -1;
my $key   = `PASSWORD_STORE_DIR=$pass_home pass show $pass_offset/$cmd`;
print $key, "\n";
do {
    $count++;
    my $now = `date +%H:%M:%S`;
    chomp $now;
    my $second = 0 + ( split( /:/, $now ) )[2];
    if ( $second == $last ) {
        next;
    }
    $last = $second;
    my $pad    = "";
    my $left   = 60 - $last;
    my $format = "%s";
    if ( $left < 10 ) {
        $pad    = "0";
        $format = "\033[1;31m%s [\033[0m";
    }

    my $token = `oathtool --base32 --totp $key`;
    chomp $token;
    system("clear");
    print sprintf(
        $format, "$now, expires: $pad$left (seconds)

$cmd
    $token

-> CTRL-C to exit
"
    );

    sleep 1;
} while ( $count <= 75 );
print "exiting (timeout)\n";
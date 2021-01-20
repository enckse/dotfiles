#!/usr/bin/perl
use warnings;
use strict;

my $rcache = "~/.cache/regen";
my $curr   = "$rcache/current";
my $prev   = "$curr.prev";
my $menu   = "~/.fluxbox/usermenu";
my $apps   = "~/.local/apps/enabled";
system("mkdir -p $rcache") if !-d $rcache;
system("ls $apps/*.app | sort > $curr");
if ( -e $prev ) {
    if ( system("diff -u $prev $curr") == 0 ) {
        exit 0;
    }
}
system("echo [separator] > $menu");
for my $app (`cat $curr | rev | cut -d '/' -f 1 | rev`) {
    chomp $app;
    if ( !$app ) {
        next;
    }
    my $name = `echo $app | cut -d '.' -f 1`;
    chomp $name;
    system("echo '[exec] ($name) {/bin/bash $apps/$app}' >> $menu");
}
system("echo [separator] >> $menu");
system("mv $curr $prev");
#!/usr/bin/perl
use warnings;
use strict;
use File::Compare;
use File::Copy qw(move);

my $home    = $ENV{"HOME"};
my $dir_env = `source $home/.variables && echo \$GIT_DIRS`;
chomp $dir_env;
my @dirs = split / /, $dir_env;
for ( "workspace", "store" ) {
    my $found = `find $home/$_/ -maxdepth 3 -type d -name ".git" | tr '\n' ' '`;
    chomp $found;
    push @dirs, split( / /, $found );
}

my $id = 500;

sub notify {
    $id += 1;
    my $cat = shift @_;
    if (@_) {
        my $text = join( "\n└ ", @_ );
        system("dunstify -r $id -t 45000 '$cat:\n└ $text'");
    }
    else {
        system("dunstify -C $id");
    }
}

my @git;
for my $dir (@dirs) {
    my $dname = `dirname $dir`;
    chomp $dname;
    my $count = 0;
    for my $git (
        "update-index -q --refresh",
        "diff-index --name-only HEAD --",
        "status -sb | grep ahead",
        "ls-files --other --exclude-standard"
      )
    {
        $count += `git -C $dname $git | wc -l`;
    }
    if ( $count > 0 ) {
        $dname =~ s#$home#~#g;
        push @git, "$dname [$count]";
    }
}

notify "git", @git;

my @mail;
my $imap = "$home/store/imap/fastmail";
if ( -d $imap ) {
    for (`find $imap -type d -name new -exec dirname {} \\; | grep -v Trash`) {
        chomp;
        my $count = `ls "$_/new/" | wc -l`;
        chomp $count;
        if ( $count > 0 ) {
            my $dname = $_;
            $dname =~ s#$imap/##g;
            push @mail, "$dname [$count]";
        }
    }
}

notify "mail", @mail;

my @kernel;
if ( `uname -r | sed "s/-arch/.arch/g"` ne
    `pacman -Qi linux | grep Version | cut -d ":" -f 2 | sed "s/ //g"` )
{
    push @kernel, "old kernel loaded";
}

notify "kernel", @kernel;

my @workspaces;
for my $desktop (`wmctrl -d | grep -v "\*" | cut -d ' ' -f 1`) {
    chomp $desktop;
    if ( $desktop eq "" ) {
        next;
    }
    my $workspace =
`wmctrl -l | cut -d ' ' -f 2- | sed 's/^\\s*//g' | grep '^$desktop ' | wc -l`
      + 0;
    if ( $workspace > 0 ) {
        my $number = $desktop + 1;
        push @workspaces, "W$number [$workspace]";
    }
}

notify "workspaces", @workspaces;

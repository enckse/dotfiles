#!/usr/bin/perl
use strict;
use warnings;

my $home      = $ENV{"HOME"};
my $mutt_home = "$home/.mutt/";
my $script    = "perl ${mutt_home}mail.pl";
my $imap      = "$home/.mutt/maildir/fastmail/";
my $mutt      = "$home/store/active/hosted/files/mutt/";

my $mail_dir     = "/tmp/muttsync";
my $mutt_session = "muttsess";
my $start_mutt   = "$mail_dir/start";

if (@ARGV) {
    my $command = $ARGV[0];
    if ( $command eq "poll" ) {
        mkdir $mail_dir if !-d $mail_dir;
        my $time = `date +%Y-%m-%d-%H-`;
        chomp $time;
        my $minute     = `date +%M` + 0;
        my $add_minute = "60";
        if ( $minute < 15 ) {
            $add_minute = "00";
        }
        elsif ( $minute < 30 ) {
            $add_minute = "30";
        }
        elsif ( $minute < 45 ) {
            $add_minute = "45";
        }
        $time = "$time$add_minute";
        my $mail_file = $mail_dir . "/$time";
        exit if -e "$mail_file";
        print "syncing mail via polling $time\n";
        system("$script sync");
        system("touch $mail_file");
        for ( ( $mutt, $mail_dir ) ) {
            system("find $_ -type f -mmin +60 -delete");
        }
    }
    elsif ( $command eq "mutt-client" ) {
        my $wait = 1;
        while ( $wait == 1 ) {
            if (
                system("tmux has-session -t $mutt_session > /dev/null 2>&1") !=
                0 )
            {
                system("touch $start_mutt");
                sleep 1;
                next;
            }
            $wait = 0;
        }
        system("tmux attach -t $mutt_session");
    }
    elsif ( $command eq "mutt-daemon" ) {
        while (1) {
            if ( -e $start_mutt ) {
                system(
"tmux new-session -d -s $mutt_session -- /usr/bin/mutt -F ${mutt_home}fastmail.muttrc"
                );
                unlink $start_mutt;
            }
            sleep 1;
        }
    }
    elsif ( $command eq "sync" ) {
        if ( -d $imap ) {
            exit 0 if system("pgrep -x mbsync > /dev/null") == 0;
            for ( ( "mbsync -a", "notmuch new" ) ) {
                system("$_ | systemd-cat -t 'mbsync'");
            }
        }
    }
    else {
        die "unknown command";
    }
    my $output = "${mutt}new.txt";
    system("touch $output");
    system(
"find $imap -type f -path '*/new/*' | grep -v Trash | rev | cut -d '/' -f 3- | rev | sort | sed 's#$imap##g' > $output"
    );
    exit 0;
}

sub install {
    my $file = shift @_;
    my $dest = shift @_;
    my $mode = "644";
    if (@_) {
        $mode = shift @_;
    }
    system("install -Dm$mode $mutt_home$file ${dest}$file");
}

install "notmuch-config", "$home/.";
install "mail.vim",       "$home/.vim/ftplugin/";
install "mbsyncrc",       "$home/.";
install "msmtprc",        "$home/.", "600";

my $count = 0;
while (1) {
    system("find $mutt -type f -exec chmod 644 {} \\;");
    if ( $count >= 60 ) {
        system("$script poll");
        $count = 0;
    }
    $count += 1;
    sleep 1;
}

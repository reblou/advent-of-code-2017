#!/usr/bin/perl

use strict;
use warnings;

my $sum = 0;

if(@ARGV) {
    if ($ARGV[0] == 1) {
        open(my $file, "<", "day1input");
        my @lines = <$file>;
        for my $line (@lines) {
            my @chars = split //, $line;
            my $prev = $chars[-2];
            print "prev: ", $prev, "\n";
            for my $char (@chars) {
                unless ($char eq "\n") {
                    if ($char eq $prev) {
                        $sum += $prev;
                    }
                    $prev = $char;
                }
            }
        }
        print $sum, "\n";
    } elsif ($ARGV[0] == 2) {

    }
}

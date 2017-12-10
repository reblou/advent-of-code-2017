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
        open(my $file, "<", "day2input");
        my @lines = <$file>;

        for my $line (@lines) {
            my @chars = split //, $line;
            my $num_numbers = scalar(@chars) - 1;
            my $step = $num_numbers / 2;

            my $cmp_index;
            for my $i (0 .. $num_numbers -1) {
                $cmp_index = $i + $step;
                if ($cmp_index > $num_numbers -1) {
                    $cmp_index = $step - (($num_numbers-1) - $i) - 1;
                    print "new cmp", $cmp_index, "\n";
                }

                if ($chars[$i] eq $chars[$cmp_index]) {

                    print $chars[$i], "eq", $chars[$cmp_index], "\n";
                    $sum += $chars[$i];
                }
            }
        }
        print "sum: ", $sum, "\n";
    }
}

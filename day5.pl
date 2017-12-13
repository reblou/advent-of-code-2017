#!/usr/bin/perl

use strict;
use warnings;

unless (@ARGV) {
    print "no arguments\n";
    exit;
}

open(my $file, "<", "day5input");
my @lines = <$file>;
my $index = 0;
my $tmp;
my $steps;

if ($ARGV[0] == 1) {
    while ($index <= $#lines) {
        $tmp = $lines[$index];
        $lines[$index]++;
        $index += $tmp;
        $steps++;
    }
} elsif ($ARGV[0] == 2) {
    while ($index <= $#lines) {
        $tmp = $lines[$index];
        if ($tmp > 2) {
            $lines[$index]--;
        } else {
            $lines[$index]++
        }
        $index += $tmp;
        $steps++;
    }
}

print "steps: $steps\n";

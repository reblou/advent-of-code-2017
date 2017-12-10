#!/usr/bin/perl
use List::Util qw( min max );
use strict;
use warnings;

my $sum = 0;

unless (@ARGV) {
    exit;
}

open(my $file, "<", "day2input");

my @lines = <$file>;


if ($ARGV[0] == 1) {
    for my $line (@lines) {
        my @nums = split /\s+/, $line;
        my $max = max @nums;
        my $min = min @nums;

        $sum += $max - $min;
    }
} elsif ($ARGV[0] == 2) {
    my $z;
    for my $line (@lines) {
        my @nums = split /\s+/, $line;
        for my $x (@nums) {
            for my $y (@nums) {
                if ($x == $y ) {
                    next;
                }
                $z = $x / $y;

                unless ($z =~ /\./) {
                    $sum += $z;
                }
            }
        }
    }
}

print $sum, "\n";

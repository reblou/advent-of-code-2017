#!/usr/bin/env perl

use strict;
use warnings;

unless (@ARGV) {
    print "no arguments\n";
    exit;
}

my $steps = 304;

if ($ARGV[0] == 1) {
    my @circularBuffer = (0);
    my $pos = 0;
    my $val = 1;

    for my $i (1 .. 2017) {
        $pos = nextIndex($pos, scalar @circularBuffer);
        splice @circularBuffer, ++$pos, 0, $val++;
    }

    my $ans = $circularBuffer[$pos+1];
    print "ans: $ans\n";
} elsif ($ARGV[0] == 2) {
    my $pos = 0;
    my $nextToZ = 1;

    for my $i (1 .. 50_000_000) {
        $pos = ($pos+$steps) % $i;
        unless ($pos++) {
            $nextToZ = $i;
            print "nextToZ: $nextToZ\n";
        }
    }
}

# get new index after cycling $steps through an array of given length starting at index ci
sub nextIndex {
    my ($ci, $arrayLength) = @_;

    return ($ci + $steps) % $arrayLength;
}

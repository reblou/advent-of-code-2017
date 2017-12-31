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
    my @circularBuffer = (0, 1);
    my $pos = 0;
    my $val = 2;
    my $zIndex = 0;
    my $nextToZ = 1;
    my $length = 2;

    for my $i (1 .. 50000000) {
        print "i: $i\n";
        $pos = nextIndex($pos, $length);
        if ($pos == $zIndex+1) {
            $nextToZ = $val;
        } elsif ($pos <= $zIndex) {
            $zIndex++;
        }
        $val++;
        $length++;
    }

    #my $ans = $circularBuffer[$pos+1];
    my $ans = $nextToZ;
    print "ans: $ans\n";
}

sub nextIndex {
    my ($ci, $arrayLength) = @_;
    my $i = $steps;

    while ($i > 0) {
        if (++$ci > $arrayLength-1) {
            $ci = 0;
        }
        $i--;
    }

    return $ci;
}

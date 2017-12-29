#!/usr/bin/env perl

use strict;
use warnings;

unless (@ARGV) {
    print "no arguments\n";
    exit;
}

open(my $file, "<", "day15input");
my @lines = <$file>;

my $factorA = 16807;
my $factorB = 48271;
my $divideBy = 2147483647;

my $aStart = 277;
my $bStart = 349;

if ($ARGV[0] == 1) {
    my $ans = judge(40000000, 1);
    print "total matches: $ans\n";
} elsif ($ARGV[0] == 2) {
    my $ans = judge(5000000, 2);
    print "total matches: $ans\n";

}

sub judge {
    my ($times, $part) = @_;
    my $a = $aStart;
    my $b = $bStart;
    my $matches = 0;

    for my $i (1 .. $times) {
        $a = nextVal("A", $a, $part);
        $b = nextVal("B", $b, $part);

        print "i: $i, a: $a, b: $b\n";

        if (lowest16Match($a, $b)) {
            print "--Match--\n";
            $matches++;
        }
    }
    return $matches;
}

sub lowest16Match {
    my ($x, $y) = @_;

    $x = $x & 0b00000000000000001111111111111111;
    $y = $y & 0b00000000000000001111111111111111;

    return ($x == $y);
}

sub nextVal {
    my ($gen, $prev, $part) = @_;
    my $factor;
    my $val;
    my $mod;


    if ($gen eq "A") {
        $factor = $factorA;
        $mod = 4;
    } elsif ($gen eq "B") {
        $factor = $factorB;
        $mod = 8;
    }

    if ($part == 1) {
        return ($prev * $factor) % $divideBy;
    } else {
        $val = $prev;
        while (($val = ($val * $factor) % $divideBy) % $mod) {}
        return $val;
    }


}

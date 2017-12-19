#!/usr/bin/env perl

use strict;
use warnings;

use POSIX;

unless (@ARGV) {
    print "no arguments\n";
    exit;
}

my @input = generateInput(256);
open(my $file, "<", "day10input");
my @lines = <$file>;

if ($ARGV[0] == 1) {
    my @lengths = linesToArr($lines[0]);
    my @arr = @input;
    my $currentIndex = 0;
    my $skipSize = 0;
    print "lengths: @lengths\n";

    foreach (@lengths) {
        print "--length $_--\n";
        @arr = reverseSection($_, $currentIndex, @arr);
        $currentIndex = moveIndex($_ + $skipSize++, $currentIndex, @arr);
        print "----\n";
    }
    print "multiplying [0] by [1]: " . ($arr[0] * $arr[1]) . "\n";
} elsif ($ARGV[0] == 2) {

}

sub generateInput {
    my $length = shift;
    my @arr;

    for my $i (0 .. $length-1) {
        push @arr, $i;
    }
    return @arr;
}

sub reverseSection {
    my ($length, $startindex, @arr) = @_;
    #print "old arr: @arr\n";
    my @indexes = cycleArray($length, $startindex, @arr);
    #print "indexes: @indexes\n";
    my $upto = floor(($length)/2) - 1;
    my $endofSection = $length+$startindex;
    my $tmp;
    #print "upto: $upto\n";

    for my $i (0 .. $upto) {
        #print "switching: " .
        #$arr[$indexes[$i]] . "&" . $arr[$indexes[$#indexes-$i]] . "\n";
        $tmp = $arr[$indexes[$i]];
        $arr[$indexes[$i]] = $arr[$indexes[$#indexes-$i]];
        $arr[$indexes[$#indexes-$i]] = $tmp;
    }
    #print "new arr: @arr\n";
    return @arr;
}

sub linesToArr {
    my $line = shift;
    $line =~ s/\s+$//g;
    my @arr = split /,/, $line;
    return @arr;
}

sub moveIndex {
    my ($amount, $index, @arr) = @_;

    while ($amount > 0) {
        if (++$index > $#arr) {
            $index = 0;
        }
        $amount--;
    }
    return $index;
}

sub cycleArray {
    my ($amount, $index, @arr) = @_;
    my @indexes = ($index);

    while ($amount > 1) {
        if (++$index > $#arr) {
            $index = 0;
        }
        push @indexes, $index;
        $amount--;
    }
    return @indexes;
}

#!/usr/bin/env perl

use strict;
use warnings;

use Data::Dumper;

unless (@ARGV) {
    print "no arguments\n";
    exit;
}

open(my $file, "<", "day13input");
my @lines = <$file>;

if ($ARGV[0] == 1) {
    # part 1
    my %hash = genHash();
    (my $end = $lines[$#lines]) =~ s/:[\s\S]*//g;
    my $ans = cycle($end, %hash);
    print "ans: $ans\n"

} elsif ($ARGV[0] == 2) {
    # part 2
    my %hash = genHash();
    (my $end = $lines[$#lines]) =~ s/:[\s\S]*//g;
    my $delay = 2;
    #my $ans = cycleDelay($end, $delay, %hash);
    my $ans = findDelay($end, %hash);
    print "ans: $ans\n";

}

sub findDelay {
    my ($end, %hash) = @_;
    my $severity;
    my $i = 1;

    while (($severity = cycleDelay($end, $i, %hash)) != 0) {
        print "severity: $severity\n";
        $i++;
    }
    print "severity: $severity\n";

    return $i;
}

sub cycle {
    my ($end, %hash) = @_;
    my $totalSev = 0;

    for my $i (0 .. $end) {
        if (exists $hash{$i}) {
            unless ($i % (($hash{$i}-1)*2)) {
                print "caught at $i\n";
                $totalSev += ($i * $hash{$i});

            }
        }

    }
    return $totalSev;
}

sub cycleDelay {
    my ($end, $delay, %hash) = @_;
    my $caught = 0;

    for my $i (0 .. $end) {
        if (exists $hash{$i}) {
            print "delay: $delay, H: $hash{$i}, i: $i\n";
            unless ((($i+$delay) % (($hash{$i}-1)*2))) {
                print "caught at $i\n";
                return 1;
            }
        }

    }
    return 0;
}


# get a hash with depths > 1 from input
sub genHash {
    my $depth;
    my $range;
    my %hash;


    foreach (@lines) {
        ($depth = $_) =~ s/:[\s\S]*//g;
        ($range = $_) =~ s/[0-9]+: //g;
        $range =~ s/\s+$//g;
        $hash{$depth} = $range;
    }
    print Dumper \%hash;
    return %hash;

}

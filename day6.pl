#!/usr/bin/perl

use strict;
use warnings;
use List::Util qw(min max);
use Data::Dumper;

unless (@ARGV) {
    print "no arguments\n";
    exit;
}

open(my $file, "<", "day6input");
my @lines = <$file>;
my @mem = split /\s+/, $lines[0];
my $num_banks = @mem;
print "num_banks: $num_banks, mem: @mem\n";
my @ans;
my $max;
my $max_index;
my @history;
my $hi = 0;
my $unique = 1;
my $loop = 0;
my $steps = 0;
my $last_seen;


if ($ARGV[0] == 1) {
    while (!$loop) {
        @ans = mostBlocks(@mem);
        $max = shift @ans;
        $max_index = shift @ans;
        my $index = $max_index;
        @mem[$max_index] = 0;
        while ($max > 0) {
            $index = indexCycle($index);
            $mem[$index]++;
            $max--;
        }
        print "mem: @mem\n";

        $loop = seen(@history, @mem, scalar(@mem));
        #print "~*~ seen = $int\n";

        #push @history, \@mem;
        for my $n (0..$#mem) {
            $history[$hi][$n] = $mem[$n];
        }
        $hi++;

        #print Dumper \@history;
        print "----\n";
        $steps++;
    }
} elsif ($ARGV[0] == 2) {
}

#print Dumper \@history;
#print "history: @history\n";
print "steps: $steps, lastseen: $last_seen\n";

sub indexCycle {
    my $index = shift;

    if ($index == $#mem) {
        return 0;
    } else {
        return ++$index;
    }
}

sub mostBlocks {
    my @mem = @_;
    my $max = 0;
    my $index = 0;

    for my $i (0..$#mem) {
        if ($mem[$i] > $max) {
            $max = $mem[$i];
            $index = $i;
        }
    }
    return ($max, $index);
}

sub seen {
    my @history = @_;
    my $mem_blocks = pop @history;
    my @checking = splice(@history, scalar(@history)-$mem_blocks, $mem_blocks);
    #print "checking: @checking\n";
    #print "d: " . Dumper \@history;
    my $match = 1;
    my $gap = 0;

    for my $n (0..$#history) {
        $last_seen = @history - $gap;
        $match = 1;
        for my $i (0..$#checking) {
            #print "n: $n, i: $i\n";
            #print "thingy: $history[$n][$i]\n";
            unless ($history[$n][$i] == $checking[$i]) {
                $match = 0;
            }
        }
        if ($match) {
            return 1;
        }
        $gap++;
    }
    return 0;
}

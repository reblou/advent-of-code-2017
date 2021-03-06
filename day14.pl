#!/usr/bin/env perl

use strict;
use warnings;

use POSIX;

unless (@ARGV) {
    print "no arguments\n";
    exit;
}

my @input = generateInput(256);
open(my $file, "<", "day14input");
my @lines = <$file>;
my $total = 0;
my @grid = [[]];
my $groups = 0;

if ($ARGV[0] == 1) {
    for my $i (0 .. 127) {
        my $str = $lines[0];
        $str =~ s/\s+$//g;
        $str .= "-" . $i;
        #print "string: $str\n";
        my @codes = getASCIIcodes($str);
        my @endSequence = (17, 31, 73, 47, 23);
        push @codes, @endSequence;
        my @a = nRounds(64, @codes);
        my @dense = densify(@a);
        my $bin = toBinary(@dense);
        $total += printRow($bin);
    }

    print "total squares: $total\n";
} elsif ($ARGV[0] == 2) {
    for my $i (0 .. 127) {
        my $str = $lines[0];
        $str =~ s/\s+$//g;
        $str .= "-" . $i;
        my @codes = getASCIIcodes($str);
        my @endSequence = (17, 31, 73, 47, 23);
        push @codes, @endSequence;
        my @a = nRounds(64, @codes);
        my @dense = densify(@a);
        my $bin = toBinary(@dense);
        print "filling grid\n";
        fillGrid($i, $bin);
    }
    getRegions();

}

# go through the grid removing all regions and count how many there were
sub getRegions {
    my $regions = 0;

    for my $n (0 .. $#grid) {
        foreach my $i (0 .. $#{$grid[$n]}) {
            if ($grid[$n][$i]) {
                print "removing from $n, $i:\n";
                removeRegion($n, $i);
                #printGrid();
                $regions++;
            }
        }
    }
    print "regions: $regions\n";
}

# remove all connected squares to grid[n][i]
sub removeRegion {
    my ($n, $i) = @_;
    unless ($grid[$n][$i]) {
        return;
    }
    #print "-n: $n, i: $i\n";
    $grid[$n][$i] = 0;
    removeRegion($n+1, $i) if $n+1 < @grid;
    removeRegion($n-1, $i) if $n-1 >= 0;
    removeRegion($n, $i-1) if $i-1 >= 0;
    removeRegion($n, $i+1) if $i+1 < @{$grid[$n]};


}

# add a binary string at row n of the grid
sub fillGrid {
    my ($row, $str) = @_;
    my @arr = split //, $str;
    for my $i (0 .. $#arr) {
        $grid[$row][$i] = $arr[$i];
    }
}

# print disk row given a string representation of a binary number, returns total squares
sub printRow {
    my $binStr = shift;
    my @a = split //, $binStr;
    my $squares = 0;
    print "|";
    foreach (@a) {
        if ($_ eq "0") {
            print ".";
        } elsif ($_ eq "1") {
            print "#";
            $squares++;
        } else {
            print "oh dear\n";
            return;
        }
    }
    print "|\n";
    return $squares;
}

sub toBinary {
    my @arr = @_;
    my $str = "";
    my $bin = "";

    foreach(@arr) {
        $str = "";
        for my $i (0 .. 7) {
            $str .= ($_ % 2);
            $_ /= 2;
        }
        $bin .= reverse $str;
    }
    return $bin;
}

# take array of integers and compress into XOR value of each 16 element segment
sub densify {
    my @sparseHash = @_;
    my @denseHash;
    my $x;

    for my $i (0 .. (@sparseHash/16)-1) {
        my $d = 0;
        for my $x (0 .. 15) {
            $d = $d ^ $sparseHash[($i*16) + $x];
        }
        push @denseHash, $d;
    }
    #print "denshash: @denseHash\n";
    return @denseHash;

}

# a round of the Knot hash algorithm
sub hashRound {
    my ($ci, $skip, $lengths, $arr) = @_;
    my @lengths = @{$lengths};
    my @arr = @{$arr};

    foreach (@lengths) {
        @arr = reverseSection($_, $ci, @arr);
        $ci = moveIndex($_ + $skip++, $ci, @arr);
    }
    return ($ci, $skip, @arr);
}

# do n Knot hash rounds
# using @input as array in each round
sub nRounds {
    my ($n, @lengths) = @_;
    my $ci = 0;
    my $skip = 0;
    my @arr = @input;

    for my $i (1 .. $n) {
        ($ci, $skip, @arr) = hashRound($ci, $skip, \@lengths, \@arr);
    }
    return @arr;
}

# turn list of ints into array of corresponding ASCII codes.
sub getASCIIcodes {
    my $str = shift;
    $str =~ s/\s+$//g;
    my @chars = split //, $str;
    my @codes;

    foreach (@chars) {
        push @codes, ord($_);
    }
    return @codes;
}

# create array of sequential integers of length given as input
sub generateInput {
    my $length = shift;
    my @arr;

    for my $i (0 .. $length-1) {
        push @arr, $i;
    }
    return @arr;
}

# reverse the elements of a section of the given array starting at startIndex
# and of a given length. Wraps around the end of an array.
sub reverseSection {
    my ($length, $startindex, @arr) = @_;
    my @indexes = cycleArray($length, $startindex, @arr);
    my $upto = floor(($length)/2) - 1;
    my $tmp;

    for my $i (0 .. $upto) {
        $tmp = $arr[$indexes[$i]];
        $arr[$indexes[$i]] = $arr[$indexes[$#indexes-$i]];
        $arr[$indexes[$#indexes-$i]] = $tmp;
    }
    return @arr;
}

# move an array index forward by given amount of elements, wraps around the end.
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

# return a list of the next $amount indexes of an array, if traversed sequentialy
# with wrapping around the end of the array.
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

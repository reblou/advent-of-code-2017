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
        toHexOutput(@dense);
        my $bin = toBinary(@dense);
        $total += printRow($bin);
    }

    print "total squares: $total\n";
} elsif ($ARGV[0] == 2) {
    # get
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
        toHexOutput(@dense);
        my $bin = toBinary(@dense);
        #getRow($bin, $i);
        #printRow($bin);
        print "filling grid\n";
        fillGrid($i, $bin);
    }
    printGrid();
    #print "groups: $groups\n";
    #getNumGroups();
    #printEx();
    getRegions();

} elsif ($ARGV[0] == 3) {
    my @rows = ("11010100", "01010101", "00001010",
    "10101101", "01101000", "11001001", "01000100", "11010110");
    for my $i (0 .. $#rows) {
        #getRow($rows[$i], $i);
        #@{$grid[$i]} = $rows[$i];
        fillGrid($i, $rows[$i]);
    }
    printGrid();
    #print "groups: $groups\n";
    #getNumGroups();
    getRegions();

}

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

sub fillGrid {
    my ($row, $str) = @_;
    my @arr = split //, $str;
    for my $i (0 .. $#arr) {
        $grid[$row][$i] = $arr[$i];
    }
}

sub getNumGroups {
    my %nums;

    foreach my $n (0 .. 7) {
        foreach my $i (0 .. 7) {
            $nums{$grid[$n][$i]} = 1;
        }
    }

    my @k = keys %nums;
    print "groups: @k\n";
    print "number of different groups: ". (@k-1) . "\n";
}

sub printEx {
    print "--\n";
    for my $n (0 .. 7) {
        print "|";
        for my $i (0 .. 7) {
            print $grid[$n][$i];
        }
        print "|\n";
    }
    print "--\n";
}

sub printGrid {
    print "--";
    for my $x (0 .. $#grid) {
        print "\n|";
        foreach my $y (0 .. $#{$grid[$x]}) {
            if($grid[$x][$y]) {
                print "#";
            } else {
                print ".";
            }
        }
        print "|";
    }
    print "\n--\n";
}

sub getRow {
    my ($binStr, $n) = @_;
    my @a = split //, $binStr;
    for my $i (0 .. $#a) {
        if ($a[$i] eq "0") {
            $grid[$n][$i] = ".";
        } elsif ($a[$i] eq "1") {
            #push @row, "#";
            #getGroup($i, $n, @a);
            if ($n > 0 && $grid[$n-1][$i] ne ".") {
                my $back = 1;
                #while ($i-$back >= 0 && $grid[$n][$i-$back] ne ".") {
                    #pop @row;
                    #push @row, $grid[$n][$i-1];
                    #$grid[$n][$i-$back] = $grid[$n-1][$i];
                    #$back++;
                #}
                #push @row, $grid[$n-1][$i];
                $grid[$n][$i] = $grid[$n-1][$i];
            } elsif ($i > 0 && $grid[$n][$i-1] ne ".") {
                #push @row, $grid[$n][$i];
                $grid[$n][$i] = $grid[$n][$i-1];
            } else {
                #push @row, $groups++;
                $grid[$n][$i] = ++$groups;
            }
            backtrace($n, $i);
        } else {
            print "oh dear\n";
            exit();
        }
    }
}

sub backtrace {
    my ($n, $i) = @_;
    if ($grid[$n][$i] eq ".") {
        print "abort\n";
        exit();
    }
    my $groupnum = $grid[$n][$i];
    #print "backtracing for: $groupnum, at n: $n, i: $i\n";
    if ($n > 0 && $grid[$n-1][$i] ne ".") {
        $grid[$n-1][$i] = $groupnum;
        backtrace($n-1, $i);
    }

    my $pos = $i;
    while ($grid[$n][++$pos]) {
        if ($grid[$n][$i] ne ".") {
            $grid[$n][$i] = $groupnum;
        }

    }

    while ($i > 0 && $grid[$n][--$i] ne ".") {
        $grid[$n][$i] = $groupnum;
        if ($n > 0 && $grid[$n-1][$i] ne ".") {
            $grid[$n-1][$i] = $groupnum;
            backtrace($n-1, $i);
        }
    }

}

# print disk row given a string representation of a binary number
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
        #print "------\n";
        for my $i (0 .. 7) {
            $str .= ($_ % 2);
            $_ /= 2;
        }
        #print "s: $str\n";
        $bin .= reverse $str;
    }
    #print "bin: $bin\n";
    return $bin;
}

# turn a list of integers into output of their hex representation.
sub toHexOutput {
    my @arr = @_;
    my $str = "";
    foreach (@arr) {
        $str .= sprintf("%02x", $_);
    }
    #print "length hex str: " . (length $str) . "\n";
    #print "hex str: $str\n";
    return $str;
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

# turn a string with a comma seperated list of ints into an array.
sub linesToArr {
    my $line = shift;
    $line =~ s/\s+$//g;
    my @arr = split /,/, $line;
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

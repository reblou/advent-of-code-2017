#!/usr/bin/env perl

# < 4120
# < 1482
# ! 282

use strict;
use warnings;
use Data::Dumper;

unless (@ARGV) {
    print "no arguments\n";
    exit;
}
open(my $file, "<", "day12input");
my @lines = <$file>;
my @arr = [[]];
inputToArray();

if ($ARGV[0] == 1) {
    # part 1
    my @keys = getGroup(0);
    print "programs in group 0: " . scalar(@keys) . "\n";

} elsif ($ARGV[0] == 2) {
    # part 2
    my $ans = getGroups();
    print "number of groups: $ans\n";
}

# initialise 2d array with input
sub inputToArray {
    my $i = 0;
    my @a;
    foreach (@lines) {

        @a = parseLine($_);

        for my $n (0 .. $#a) {
            $arr[$i][$n] = $a[$n];
        }
        $i++;
    }
}

# parse string into array of connected programs to the index
sub parseLine {
    my $line = shift;
    $line =~ s/\s+$//g;
    (my $end = $line) =~ s/^[0-9]+ <-> //g;
    my @arr = split /, /, $end;
    return @arr;
}

# parse 2d array to get group of all programs connected to a given number
sub getGroup {
    my ($start) = @_;
    my @checkingStack;
    my %zeroGroup = ($start=>1);

    foreach (@{$arr[$start]}) {
        push @checkingStack, $_;
        $zeroGroup{$_} = 1;
    }
    my $x;

    while (defined ($x = shift(@checkingStack))) {
        foreach (@{$arr[$x]}) {
            unless (exists $zeroGroup{$_}) {
                push @checkingStack, $_;
                $zeroGroup{$_} = 1;
            }
        }

    }
    my @keys = keys %zeroGroup;
    return @keys;
}

sub getGroups {
    my $int = $#arr;
    my @notChecked = (0 .. $int);
    my $x;
    my %help;
    my @keys;
    my $groups = 0;

    while (defined ($x = shift(@notChecked))){
        @keys = getGroup($x);
        @help{@notChecked} = ();
        foreach (@keys) {
            delete $help{$_};
        }
        @notChecked = keys %help;
        $groups++;
    }
    return $groups;
}

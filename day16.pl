#!/usr/bin/env perl

use strict;
use warnings;

use List::Util qw(first);

unless (@ARGV) {
    print "no arguments\n";
    exit;
}

open(my $file, "<", "day16input");
my @lines = <$file>;
my @line;

if ($ARGV[0] == 1) {
    my $str = "abcdefghijklmnop";
    @line = split //, $str;
    print "line: @line\n";

    my $dance = $lines[0];
    $dance =~ s/\s+$//g;
    @line = parseline($dance, @line);

} elsif ($ARGV[0] == 2) {
    my $str = "abcdefghijklmnop";
    @line = split //, $str;
    my $dance = $lines[0];
    $dance =~ s/\s+$//g;
    my @end = parseline($dance, @line);
    my $n = findLoop($dance);
    my $remainder = 1000000000 % $n;
    print "remainder: $remainder\n";
    for my $i (1 .. $remainder) {
        @line = parseline($dance, @line);
    }
}

print "final line: @line\n";

# find the number of dances done before it loops
sub findLoop {
    my $dance = shift;
    my @line = split //, "abcdefghijklmnop";
    @line = parseline($dance, @line);
    my $n = 1;

    while ((join "", @line) ne "abcdefghijklmnop") {
        @line = parseline($dance, @line);
        $n++;
    }
    print "n times to loop: $n\n";
    return $n;

}

# perform dance moves on the list
sub parseline {
    my ($dance, @line) = @_;
    my @inst = split /,/, $dance;
    my $i = 0;

    my $X;
    my $A;
    my $B;

    while ($i < @inst) {
        if ($inst[$i] =~ /s/) {
            ($X = $inst[$i]) =~ s/^s//g;
            spin($X, \@line);
        } elsif ($inst[$i] =~ /x/) {
            ($A = $inst[$i]) =~ s/^x|\/[0-9]+//g;
            ($B = $inst[$i]) =~ s/^x[0-9]+\///g;

            exchange($A, $B, \@line);
        } elsif ($inst[$i] =~ /p/) {
            ($A = $inst[$i]) =~ s/^p|\/[a-z]+//g;
            ($B = $inst[$i]) =~ s/^p[a-z]\///g;

            partner($A, $B, \@line);
        }
        $i++;
    }
    return @line;
}

# move x elements from the end to the front of an array
sub spin {
    my ($x, $line) = @_;
    my @start = splice @{$line}, 0, @{$line}-$x;
    push @{$line}, @start;
}

# swap elements of a list at a and b indexes
sub exchange {
    my ($a, $b, $line) = @_;
    my $tmp = ${$line}[$a];
    ${$line}[$a] = ${$line}[$b];
    ${$line}[$b] = $tmp;
}

# swap elements a and b in the array
sub partner {
    my ($a, $b, $line) = @_;
    my $i = 0;
    my $aIndex;
    my $bIndex;

    while ($i < @{$line} && (!$aIndex || !$bIndex)) {
        if (${$line}[$i] eq $a) {
            $aIndex = $i;
        } elsif (${$line}[$i] eq $b) {
            $bIndex = $i;
        }
        $i++;
    }
    exchange($aIndex, $bIndex, $line);
}

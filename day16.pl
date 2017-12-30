#!/usr/bin/env perl

use strict;
use warnings;

use Term::ProgressBar;

unless (@ARGV) {
    print "no arguments\n";
    exit;
}

open(my $file, "<", "day16input");
my @lines = <$file>;

if ($ARGV[0] == 1) {
    my $str = "abcdefghijklmnop";
    my @line = split //, $str;
    print "line: @line\n";

    my $dance = $lines[0];
    $dance =~ s/\s+$//g;
    parseline($dance, @line);
} elsif ($ARGV[0] == 2) {
    my $str = "abcdefghijklmnop";
    my @line = split //, $str;
    my $dance = $lines[0];
    $dance =~ s/\s+$//g;
    foreach (1 .. 1000000000) {
        @line = parseline($dance, @line);
    }
    print "final line: @line\n";
}

sub parseline {
    my ($dance, @line) = @_;
    my @inst = split /,/, $dance;
    print "l: @line\n";
    print "i: @inst\n";
    my $i = 0;

    my $X;
    my $A;
    my $B;

    while ($i < @inst) {
        if ($inst[$i] =~ /s/) {
            ($X = $inst[$i]) =~ s/^s//g;
            print "s $X\n";
            spin($X, \@line);
        } elsif ($inst[$i] =~ /x/) {
            ($A = $inst[$i]) =~ s/^x|\/[0-9]+//g;
            ($B = $inst[$i]) =~ s/^x[0-9]+\///g;

            print "x, A: $A, B: $B\n";

            exchange($A, $B, \@line);
        } elsif ($inst[$i] =~ /p/) {
            ($A = $inst[$i]) =~ s/^p|\/[a-z]+//g;
            ($B = $inst[$i]) =~ s/^p[a-z]\///g;

            print "p, A: $A, B: $B\n";
            partner($A, $B, \@line);
        }
        $i++;
        print "line: @line\n";
    }
    return @line;
}

sub spin {
    my ($x, $line) = @_;
    my @start = splice @{$line}, 0, @{$line}-$x;
    push @{$line}, @start;
}

sub exchange {
    my ($a, $b, $line) = @_;
    my $tmp = ${$line}[$a];
    ${$line}[$a] = ${$line}[$b];
    ${$line}[$b] = $tmp;
}

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

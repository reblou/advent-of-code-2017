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
    print "----\n";
    my @is = simplifyDance(\@line, \@end);
    my $n = findLoop(@is);
    my $remainder = 1000000000 % $n;
    print "remainder: $remainder\n";
    for my $i (1 .. $remainder) {
        print "loop i: $i\n";
        @line = simpleDance(\@is, @line);
    }
}

print "final line: @line\n";

sub findLoop {
    my @indexes = @_;
    my @line = split //, "abcdefghijklmnop";
    @line = simpleDance(\@indexes, @line);
    my $n = 1;

    while ((join "", @line) ne "abcdefghijklmnop") {
        @line = simpleDance(\@indexes, @line);
        $n++;
    }
    print "n times to loop: $n\n";
    return $n;

}

sub simpleDance {
    my ($indexes, @line) = @_;
    my @newline;
    my $i = 0;

    foreach (@line) {
        $newline[${$indexes}[$i++]] = $_;
    }
    print "new line: @newline\n";
    return @newline;
}

sub simplifyDance {
    my ($start, $end) = @_;
    my @start = @{$start};
    my @end = @{$end};
    my @indexes;

    foreach my $s (@start) {
        my $x = (first { $end[$_] eq $s } 0..$#end);
        push @indexes, $x;
        print "index of $s is: $x\n";
    }
    print "indexes: @indexes\n";
    return @indexes;
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

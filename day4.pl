#!/usr/bin/perl

# < 392
# > 223

use strict;
use warnings;

unless(@ARGV) {
    exit;
}

my $sum = 0;
my $part;

if ($ARGV[0] == 1) {
    $part = 1;
    # 467 too high.
} elsif ($ARGV[0] == 2) {
    $part = 2;
}

open(my $file, "<", "day4input");
my @lines = <$file>;

for my $line (@lines) {
    #print "calling validate line for $line\n";
    $sum += validateLine($line, $part);
}

print "sum: " . $sum . "\n";

sub validateLine {
    my $str = shift;
    my $part = shift;

    my @words = split / /, $str;
    if (scalar(@words) < 2) {
        return 0;
    }
    for my $i (0..$#words) {
        my $word = splice(@words, $i, 1);
        my $newline = join " ", @words;

        #print "checking validity of $word, newline = $newline\n";

        if ($newline =~ /(\s+|^)$word\s+/) {
            #print "|_invalid repeating\n";
            return 0;
        }

        if ($part == 2) {
            unless (checkAnagrams($newline, $word)) {
                #print "|_invalid anagrams\n";
                return 0;
            }
        }
        splice(@words, $i, 0, $word);
    }
    #print "|_returning 1\n";
    return 1;
}

sub checkAnagrams {
    my $newline = shift;
    my $check = shift;
    my @words = split / /, $newline;
    #my $ord = stringOrd($check);
    #print "str " . $check . ", ord: " . $ord . "\n";

    foreach (@words) {
        # only checking first char in str
        my $s = $_;
        $s =~ s/\s+//g;
        $s = join "", bubbleSort(split //, $s);
        $check = join "", bubbleSort(split //, $check);
        #print "s: $s, eq, check: $check\n";
        if ($s eq $check) {
            #print "s: $s, eq, check: $check\n";
            return 0;
        }
    }
    return 1;
}

sub bubbleSort {
    my @arr = @_;
    my $swapped = 0;
    my $tmp;
    my @newArr = @arr;

    foreach (@arr) {
        $swapped = 0;
        for my $i (0..$#arr-1) {
            if (ord($newArr[$i]) > ord($newArr[$i+1])) {
                #print "switching $i and " . ($i+1) . "\n";
                $tmp = $newArr[$i];
                $newArr[$i] = $newArr[$i+1];
                $newArr[$i+1] = $tmp;
                $swapped = 1;
                #print "bs: " . (join "", @newArr) . "\n";
            }
        }
        unless ($swapped) {
            return @newArr;
        }
        #print "bs: " . (join "", @newArr) . "\n";
    }
    return @newArr;
}

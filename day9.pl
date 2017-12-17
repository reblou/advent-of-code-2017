#!/usr/bin/env perl

# < 19022
# < 18377
# not 5906
# not 5889

use strict;
use warnings;

unless (@ARGV) {
    print "no arguments\n";
    exit;
}

open(my $file, "<", "day9input");
my @lines = <$file>;
my $sum = 0;
my $garbageSum = 0;

if ($ARGV[0] == 1) {
    my $str;
    foreach (@lines) {
        $_ =~ s/\s$//g;
        $str = clearCancels($_);
        print "cancels cleared: $str\n";
        $str = clearGarbage($str);
        print "garbage cleared: $str\n";
        my $int = countGroups($str, 1);
        print "line total: $int\n";
        $sum += $int;
    }
    print "Total score for all groups: $sum\n";
} elsif ($ARGV[0] == 2) {
    my $str;
    my $x;
    foreach (@lines) {
        $_ =~ s/\s$//g;
        $str = clearCancels($_);
        $x = garbageCharacters($str);
        print "line garbage chars: $x\n";
        $garbageSum += $x;

    }
    print "Total characters in garbage: $garbageSum\n";
}


sub clearCancels {
    my $line = shift;
    $line =~ s/!\S//g;
    return $line;
}

sub clearGarbage {
    my $line = shift;
    $line =~ s/<[^>]*>[,]*//g;
    return $line;
}

sub removeGroupCommas {
    my $line = shift;
    if ($line =~ /\{[^\}]*,/) {
        $line =~ s/(?<=\{)//g;
    }

}

sub garbageCharacters {
    my $line = shift;
    my $total = 0;

    while ($line =~ /<([^>]*)>/) {
        $total += length $1;
        $line =~ s/<([^>]*)>//;

    }
    return $total;

}

sub countGroups {
    my ($line, $layer) = @_;
    my $tmp;
    #print "---layer: $layer---\n";

    unless ($line) {
        print "line empty returning: $layer\n";
        return $layer;
    }

    my @chars = split //, $line;
    my $c;
    my $level = 0;
    my $sum = 0;


    while ($c = shift @chars) {
        if ($c eq "{") {
            #print "open curly\n";
            $level++;
        } elsif ($c eq "}") {
            #print "closing curly, sum += $level\n";
            $sum += $level--;
        }

    }
    return $sum;
}

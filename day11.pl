#!/usr/bin/env perl

use strict;
use warnings;
use POSIX;

unless (@ARGV) {
    print "no arguments\n";
    exit;
}

open(my $file, "<", "day11input");
my @lines = <$file>;

if ($ARGV[0] == 1) {
    $lines[0] =~ s/\s+$//g;
    my @directions = split /,/, $lines[0];
    my @coordinates = processDirections(@directions);
    my $steps = stepDistance(@coordinates);
    print "steps: $steps\n";

} elsif ($ARGV[0] == 2) {
    $lines[0] =~ s/\s+$//g;
    my @directions = split /,/, $lines[0];
    my $max = maxDistance(@directions);
    print "max steps: $max\n";

}

# max number of steps at any point while following directions
sub maxDistance {
    my @directions = @_;
    my @coords = (0,0);
    my $x;
    my $y;
    my $maxSteps = 0;
    my $steps;

    foreach (@directions) {
        if ($_ =~ /n/) {
            $y = 1;
        } elsif ($_ =~ /s/) {
            $y = -1;
        }

        if ($_ =~ /[ns]$/) {
            $y *= 2;
        }

        if ($_ =~ /e/) {
            $x = 1;
        } elsif ($_ =~ /w/) {
            $x = -1;
        } else {
            $x = 0;
        }

        $coords[0] += $x;
        $coords[1] += $y;

        $steps = stepDistance(@coords);
        if ($steps > $maxSteps) {
            $maxSteps = $steps;
        }
    }
    return $maxSteps;
}

# turn array of direction strings into coordinate
sub processDirections {
    my @dirs = @_;
    my @coords = (0, 0);
    my $y;
    my $x;

    foreach (@dirs) {
        if ($_ =~ /n/) {
            $y = 1;
        } elsif ($_ =~ /s/) {
            $y = -1;
        }

        if ($_ =~ /[ns]$/) {
            $y *= 2;
        }

        if ($_ =~ /e/) {
            $x = 1;
        } elsif ($_ =~ /w/) {
            $x = -1;
        } else {
            $x = 0;
        }

        $coords[0] += $x;
        $coords[1] += $y;
    }
    return @coords;
}

# hexagons from start from coordinates
sub stepDistance {
    my ($x, $y) = @_;
    my $distance = 0;
    $x = abs($x);
    $y = abs($y);

    while ($x > 0) {
        $distance++;
        $x--;
        $y--;
    }
     if ($y < -0) {
         $y = 0;
     }
    return $distance + $y;
}

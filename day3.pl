#!/usr/bin/perl
use strict;
use warnings;

my $sum = 0;

unless (@ARGV) {
    exit;
}

#my $input = 265149;
my $input = $ARGV[1];
my @memory = ((0,0), (0,0));
my $ring = 1;
my $steps;


if ($ARGV[0] == 1) {
    my @ans = squares($input);

    print "ans: \n";
    foreach (@ans) {
        print "$_, ";
    }
    print "\n";

    my $rings = @ans;
    #'print pop @ans,  "\n";
    my @sol = getCoord(@ans, $rings, $input);
    print "sol:\n";
    foreach (@sol) {
        print "$_, ";
    }
    print "\n";
    $steps = distFromCoord(@sol);
} elsif ($ARGV[0] == 2) {
    my @ans = squares($input);

    my $rings = @ans;
    my $dimension = 2 * $rings - 1;
    my @grid;

    for my $i (0..$dimension) {
        for my $n (0..$dimension) {
            push $grid[$i], 0;
        }
    }

    foreach (@grid) {
        print "$_\n";
    }


}

print "steps: " . $steps . "\n";

sub squares {
    my $upto = shift;
    my $square = 1;
    my $i;
    my @sqs;

    do  {
        $i = $square**2;
        push @sqs, $i;
        $square += 2;
    } while ($i < $upto);

    return @sqs;
}

sub sumUp {
    my $x = shift;
    my $i = 1;

    while ($x > 1) {
        $i += 2;
        $x--;
    }

    return $i;
}

sub getCoord {
    my @squares = @_;
    my $x = pop @squares;
    my $rings = pop @squares;
    my $br = pop @squares;

    if ($br == $x) {
        my $c = -($rings-1);
        return ($rings-1, $c);
    }
    my $ringstart = pop @squares;
    my $blockDimensions = sumUp($rings);
    my $dist = $x - $ringstart;
    print "x: " . $x . "\n";
    #my ($cx, $cy) = getCoord($ringstart, $rings-1, $ringstart);

    if ($x <= ($ringstart + $blockDimensions - 1)) {
        return ($rings-1, $dist-($rings-1));
    } elsif ($x <= ($ringstart + 2*($blockDimensions - 1))) {
        print "x: " . $x . ", rs: $ringstart, bd: $blockDimensions, d: $dist\n" ;

        return (($rings - 1) - ($dist - $blockDimensions + 1), $rings-1);
    } elsif ($x <= ($ringstart + 3*($blockDimensions - 1))) {
        return (-($rings-1), -($dist-($rings-1)-2*($blockDimensions-1)));
    } else {
        return ( -((($rings - 1) - ($dist - 3*($blockDimensions - 1)))), 1-$rings)
    }

}

sub distFromCoord {
    my ($x, $y) = @_;
    return (abs($x) + abs($y))

}

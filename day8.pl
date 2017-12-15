#!/usr/bin/env perl

use strict;
use warnings;

use Data::Dumper;

unless (@ARGV) {
    print "no arguments\n";
    exit;
}

open(my $file, "<", "day8input");
my @lines = <$file>;

if ($ARGV[0] == 1) {
    my %registers = initialiseRegisters();
    evalConds(%registers);

} elsif ($ARGV[0] == 2) {

}

sub initialiseRegisters {
    my %registers;
    my $reg;

    print "Registers:\n";
    foreach (@lines) {
        ($reg = $_) =~ s/\s+[\s\S]*//g;
        print "" . $reg . "\n";
        $registers{$reg} = 0;
    }
    print "--\n";
    return %registers;
}

sub evalConds {
    my %registers = @_;
    my $str;
    my $reg;
    my $totalMax = 0;
    my $x;

    foreach (@lines) {
        ($str = $_) =~ s/.*if [a-z]+//g;
        ($reg = $_) =~ s/(.*if )|(\s+.*)//g;
        print "" . $registers{$reg} . $str . "\n";
        if (eval ( "" . $registers{$reg} . $str)) {
            %registers = evalExpr($_, %registers);
        }
        $x = findMaxVal(%registers);

        if ($x > $totalMax) {
            $totalMax = $x;
        }
    }

    print Dumper \%registers;
    print "max: " . findMaxVal(%registers) . "\n";
    print "total max: $totalMax\n";
}

sub findMaxVal {
    my %registers = @_;
    my $max = 0;

    foreach my $val (values %registers) {
        if ($val > $max) {
            $max = $val;
        }
    }
    return $max;
}

sub evalExpr {
    my ($line, %registers) = @_;
    my $reg;
    my $expr;
    my $val;

    #print "line: $line\n";
    ($reg = $line) =~ s/\s+[\s\S]*//g;
    ($expr = $line) =~ s/(^[a-z]+ )|( [\s\S]*$)//g;
    ($val = $line) =~ s/(^[a-z]+ [a-z]+ )|( if[\s\S]*$)//g;
    #print "reg: $reg, $expr, $val\n";

    if ($expr eq "inc") {
        $registers{$reg} += $val;
    } elsif ($expr eq "dec") {
        $registers{$reg} -= $val;
    } else {
        print "Not an inc or dec\n";
    }
    return %registers;
}

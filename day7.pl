#!/usr/bin/perl

use strict;
use warnings;

unless(@ARGV) {
    print "no args\n";
    exit;
}

open(my $file, "<", "day7input");
my @lines = <$file>;
my $children_str;
my @children;
my @all_children;
my @programs;
my $progstr;

if ($ARGV[0] == 1) {
    foreach (@lines) {
        $children_str = $_;
        $children_str =~ s/.*\([0-9]+\)( -> |$)//g;
        #print "cs: $children_str\n";
        #$children_str =~ s/
        @children = split /,*\s+/, $children_str;
        #print "children: '@children'\n";
        foreach (@children) {
            #print "-'$_'\n";
            push @all_children, $_;
        }

        $progstr = $_;
        $progstr =~ s/\s+.*$//g;
        #print "ps: $progstr\n";
        push @programs, $progstr;
    }
    my $root;
    foreach (@programs) {
        $root = 1;
        for my $i (0..$#all_children) {
            if ($all_children[$i] =~ /^$_$/) {
                $root = 0;
            }
        }
        if ($root) {
            print "ans: $_\n";
        }

    }



} elsif ($ARGV[0] == 2) {

}

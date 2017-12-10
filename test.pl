#!/usr/bin/perl

use strict;
use warnings;

sub fib {
  my $x = shift;

  if ($x <= 1) {
      return $x;
  }
  return fib($x-1) + fib($x-2);
}

my $x = 1;
my $y = 1;
my $tmp;

for my $i (1..10) {
    print fib($i), "\n";
}

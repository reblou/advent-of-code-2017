#!/usr/bin/perl

use strict;
use warnings;

package Node;

sub new {
    my ($class, $args) = @_;
    my $self = bless {
        name => $args->{name},
        value => $args->{value}
        }, $class;
    $self->{children} = [];
    #print "initialized\n";
    return $self;
}

sub printTree {
    my $node = shift;
    my $level = shift;
    unless ($node->{value}) {
        return -1;
    }
    my $i = $level;
    while ($i > 0) {
        print " ";
        $i--;
    }
    print "|-name: $node->{name}, val: $node->{value}\n";
    unless ($node->{children}) {
        print "no children\n";
        return -1;
    }
    $level++;
    for my $i (0 .. $#{$node->{children}}) {
            #print "'$_': $_\n";
            printTree($node->{children}[$i], $level);
    }
}

sub addChild {
    my ($self, $new_child) = @_;

    #print "new child $new_child->{value}, $new_child->{name}\n";

    #print "old no children: " . @{$self->{children}} . "\n";
    push @{$self->{children}}, $new_child;
    #print "new no children: $i\n";
    #$self->{children_index} = $i++;

    #$self;
}

sub getSubTreeWeight {
    my $self = shift;

    my $sum = $self->{value};

    for my $i (0 .. $#{$self->{children}}) {
        $sum += $self->{children}[$i]->getSubTreeWeight();
    }

    return $sum;
}

1;

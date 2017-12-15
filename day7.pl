#!/usr/bin/perl

use strict;
use warnings;

use Data::Dumper;

use FindBin;
use lib $FindBin::Bin;

use Node;

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

my $line;
my $name;
my $value;
my %weights;
my %nodes;
my $node;
my $child_node;
my %nodeChildren;

if ($ARGV[0] == 1) {
    print "root: " . getRoot() . "\n";
} elsif ($ARGV[0] == 2) {
        ## currently just getting nodes + their direct children
        ## seperate from the rest of the tree.
    getWeights();
    #print Dumper(\%weights);
    foreach (@lines) {
        $line = $_;

        ($name = $line) =~ s/\s+.*//g;
        ($value = $line) =~ s/(.*\()|\)[\s\S]*//g;
        ($children_str = $line) =~ s/.*\([0-9]+\)( -> |$)//g;
        @children = split /,*\s+/, $children_str;

        $node = Node->new( {name=>$name, value=>$value} );

        #print "name: '$name'\n";
        #print "val: '$value'\n";
        #print "c: '@children'\n";
        my @a;
        foreach (@children) {
            print "adding $_ weight: $weights{$_} to $name\n";
            #$child_node = Node->new( {name=>$_, value=>$weights{$_}});
            #$node->addChild($child_node);
            push @a, $_;
        }
        $nodeChildren{$name} = \@a;
        $nodes{$name} = $node;
        #print Dumper \$node;
    }

    #print Dumper(\%weights);
    #print Dumper \%nodes;

    foreach my $key (keys %nodeChildren) {
        foreach (@{$nodeChildren{$key}}) {
            $nodes{$key}->addChild($nodes{$_});
        }

        print "--\n";
    }

    $nodes{getRoot()}->printTree(0);
    print "weight: " . $nodes{getRoot()}->getSubTreeWeight() . "\n";
    #print Dumper \($nodes{getRoot()});

}

sub getWeights {
    foreach (@lines) {
        $line = $_;

        ($name = $line) =~ s/\s+.*//g;
        ($value = $line) =~ s/(.*\()|\)[\s\S]*//g;

        $weights{$name} = $value;
    }
}

sub getUnbalanced {
    #TODO: this stuff
    my $node = shift;
    my $weight

    for my $i (0 .. $#{$node->{children}}) {
        $node->{children}[$i]->getSubTreeWeight();
    }

}

sub getRoot {
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
            #print "ans: $_\n";
            return $_;
        }
    }
    return "";
}

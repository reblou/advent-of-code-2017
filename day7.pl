#!/usr/bin/perl

use strict;
use warnings;

use Data::Dumper;
use List::Util qw (min max);

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
            #print "adding $_ weight: $weights{$_} to $name\n";
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

        #print "--\n";
    }

    $nodes{getRoot()}->printTree(0);
    print "weight: " . $nodes{getRoot()}->getSubTreeWeight() . "\n";
    #print Dumper \($nodes{getRoot()});

    getUnbalanced($nodes{getRoot()});
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
    #TODO: find the one node weight that needs to be changed
    #TODO: and how much to change it by
    my $node = shift;
    my $unbalanced;
    my $kids = $node->{children};
    print "kids: @{$kids}\n";
    my @kids = @{$kids};
    my @kidvals;

    print "root balanced: " . childrenBalanced($node) . "\n";

    for my $i (0 .. $#kids) {
        print "i: $i\n";
        print "$kids[$i]->{name} :" . childrenBalanced($kids[$i]) . "\n";
        unless (childrenBalanced($kids[$i])) {
            return getUnbalanced($kids[$i]);
        }
    }

    getUnique(@kids)
}

sub getUnique {
    my @nodes = @_;
    my %namevals;
    my %vals;
    my $needschanging;

    foreach (@nodes) {
        print "$_->{name}\n";
        $vals{$_->getSubTreeWeight()}++;
        $namevals{$_->{name}} = $_->getSubTreeWeight;
    }
    print Dumper \%vals;
    my $min;
    my $minKey;
    my $diff;

    foreach my $key (keys %vals) {
        unless ($min) {
            $min = $vals{$key};
            $minKey = $key;
        } elsif ($vals{$key} < $min) {
            $min = $vals{$key};
            $minKey = $key;
        } else {
            $diff = $minKey - $key;
        }
    }

    print "min val: $minKey: $min\n";

    foreach my $key (keys %namevals) {
        if ($namevals{$key} == $minKey) {
            $needschanging = $key;
            print "min name: $key, diff: $diff\n";
            print "new value: " . ($weights{$key}-$diff) . "\n";
        }
    }
}

sub childrenBalanced {
    my $node = shift;
    my @kids = @{$node->{children}};

    for my $i (0 .. $#kids-1) {
        #print $kids[$i]->getSubTreeWeight() . "\n";
        #print $kids[$i+1]->getSubTreeWeight() . "\n";
        if ($kids[$i]->getSubTreeWeight() != $kids[$i+1]->getSubTreeWeight()) {
            return 0;
        }
    }
    return 1;
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

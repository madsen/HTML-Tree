#! /usr/bin/perl
#---------------------------------------------------------------------
# Test whether parsing can preserve whitespace

use strict;
use warnings;

use Test::More;

use HTML::TreeBuilder;

my @tests = (
 '<p>I <b>Like</b> <ul>Pie</ul>!</p>',
 '<p>I <b>Like </b>  <ul>   Pie</ul>!</p>',
 "<p>This has a newline\nhere.</p>",
 "<p>This has two newlines\n\nhere.</p>",
 "<p>This\xA0has nbsp: \xA0 </p>",
);

plan tests => scalar @tests;

for my $test (@tests) {
    my $tree = HTML::TreeBuilder->new;

    $tree->ignore_ignorable_whitespace(0);
    $tree->no_space_compacting(1);

    $tree->parse_content($test);

    my ($name) = ($test =~ /^(.*)/);

    is($tree->look_down(qw(_tag body))->as_HTML('<>&', undef, {}),
       "<body>$test</body>", $name);
} # end for each $test in @tests

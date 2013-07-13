#! /usr/bin/perl
#---------------------------------------------------------------------
# Test with the implicit_tags attribute off (because it's usually on)

use strict;
use warnings;

use Test::More 0.88;            # done_testing
use t::Util;

use HTML::TreeBuilder;

plan tests => 9;

#---------------------------------------------------------------------
sub parse
{
    my $tree = HTML::TreeBuilder->new_from_string(@_, implicit_tags => 0);

    my @implicit = $tree->look_down(_implicit => 1);

    local $Test::Builder::Level = $Test::Builder::Level + 1;
    isa_ok($tree, 'HTML::Element');

    is_deeply(\@implicit, [ $tree ], "only 1 implicit tag");

    $tree;
} # end parse

#---------------------------------------------------------------------
is(xml(parse('<html><head></head><body></body></html>')),
       '<html><html><head></head><body></body></html></html>',
   '<html> is duplicated');

is(xml(parse('<p>1<p>2')),
       '<html><p>1<p>2</p></p></html>', "no implicit end tags");

is(xml(parse('<p>1</p><p>2')),
       '<html><p>1</p><p>2</p></html>', "explicit end tags work");

#---------------------------------------------------------------------
done_testing;

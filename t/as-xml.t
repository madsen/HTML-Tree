#! /usr/bin/perl
#---------------------------------------------------------------------
# Test the as_XML & content_as_XML methods

use strict;
use warnings;

use Test::More 0.88;            # done_testing

use HTML::Element;

plan tests => 9;

#---------------------------------------------------------------------
sub t
{
    my ($name, $lol, $starttag, $endtag, $expected) = @_;

    my $tree = HTML::Element->new_from_lol($lol);

    local $Test::Builder::Level = $Test::Builder::Level + 1;
    isa_ok($tree, 'HTML::Element', $name);

    is($tree->content_as_XML, "$expected\n", "$name content_as_XML");

    is($tree->as_XML, $starttag . $expected . "$endtag\n", "$name as_XML");
} # end t

#---------------------------------------------------------------------
t('simple <p>', [p => 'Hello'], '<p>', '</p>', 'Hello');

t('<p> with <em>', [p => 'Hello, ', [ em => 'world' ], '.'],
  '<p>', '</p>', 'Hello, <em>world</em>.');

t('nested <div>s', [ div => [div => '1'], [div => '2'] ],
  '<div>', '</div>', '<div>1</div><div>2</div>');

#---------------------------------------------------------------------
done_testing;

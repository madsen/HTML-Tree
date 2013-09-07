#! /usr/bin/perl
#---------------------------------------------------------------------
# Test the as_HTML & content_as_HTML methods

use strict;
use warnings;

use Test::More 0.88;            # done_testing

use HTML::Element;

plan tests => 18;

#---------------------------------------------------------------------
sub t
{
    my ($name, $args, $lol, $starttag, $endtag, $expected) = @_;

    my $tree = HTML::Element->new_from_lol($lol);

    local $Test::Builder::Level = $Test::Builder::Level + 1;
    isa_ok($tree, 'HTML::Element', $name);

    is($tree->content_as_HTML(@$args), $expected, "$name content_as_HTML");

    is($tree->as_HTML(@$args), $starttag . $expected . $endtag, "$name as_HTML");
} # end t

#---------------------------------------------------------------------
my $allEnd = [undef,undef,{}];
my $nil = [];

t('simple <p>', $nil, [p => 'Hello'], '<p>', '', 'Hello');

t('simple <p></p>', $allEnd, [p => 'Hello'], '<p>', '</p>', 'Hello');

t('<p> with <em>', $nil, [p => 'Hello, ', [ em => 'world' ], '.'],
  '<p>', '', 'Hello, <em>world</em>.');

t('<p> with <em> and </p>', $allEnd, [p => 'Hello, ', [ em => 'world' ], '.'],
  '<p>', '</p>', 'Hello, <em>world</em>.');

t('nested <div>s', $nil, [ div => [div => '1'], [div => '2'] ],
  '<div>', '</div>', '<div>1</div><div>2</div>');

t('nested <div>s indented', [undef, '  '], [ div => [div => '1'], [div => '2'] ],
  "<div>", "</div>", "\n  <div>1</div>\n  <div>2</div>\n");

#---------------------------------------------------------------------
done_testing;

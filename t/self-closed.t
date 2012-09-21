#! /usr/bin/perl
#---------------------------------------------------------------------
# Test the self_closed_tags attribute

use strict;
use warnings;

use Test::More 0.88;            # done_testing
use t::Util;

use HTML::TreeBuilder;

plan tests => 36;

#---------------------------------------------------------------------

my $xhtml = HTML::TreeBuilder->new_from_file('t/sample.xhtml',
                                             self_closed_tags => 1);

isa_ok($xhtml, 'HTML::Element');

is(scalar $xhtml->look_down('/' => qr/.?/), undef, 'no / attributes');

ok($xhtml->look_down(id=>$_)->is_empty, "$_ is empty")
    for qw(a1 a1-1 a1-2 a2 a4);

ok( ! $xhtml->look_down(id=>$_)->is_empty, "$_ is not empty")
    for qw(p1 p2 p3 a3 p4);

isa_ok(my $p1 = $xhtml->look_down(id=>'p1'), 'HTML::Element');

is($p1->as_trimmed_text, 'This is paragraph 1.', 'p1 text matches');

is(xml($p1),
   '<p id="p1"><a id="a1"></a>This <a id="a1-1"></a>' .
   'is paragraph <a id="a1-2"></a>1.</p>',
   'p1 content');

is($xhtml->look_down(id=>'p2')->as_trimmed_text,
   'This is paragraph 2.',
   'p2 text matches');

is($xhtml->look_down(id=>$_)->as_trimmed_text,
   'This is paragraph 3.',
   "$_ text matches") for qw(p3 a3);

isa_ok(my $p4 = $xhtml->look_down(id=>'p4'), 'HTML::Element');

is($p4->as_trimmed_text,
   'This is paragraph 4 on two lines.',
   'p4 text matches');

is(xml($p4),
   '<p id="p4"><a id="a4"></a>This is paragraph 4<br /> on two lines.</p>',
   'p4 content');

undef $xhtml;

#---------------------------------------------------------------------
# Some tests without self_closed_tags:

my $html = HTML::TreeBuilder->new_from_file('t/sample.xhtml');

isa_ok($html, 'HTML::Element');

isnt(scalar $html->look_down('/' => qr/.?/), undef, 'HTML has / attributes');

ok( ! $html->look_down(id=>$_)->is_empty, "HTML $_ is not empty")
    for qw(a1 a1-1 a1-2 a2 a3 a4 p1 p2 p3 p4);

is($html->look_down(id=>'a1-1')->as_trimmed_text,
   'is paragraph 1.',
   'HTML a1-1 text matches');

is(xml(scalar $html->look_down(id=>'p1')),
   '<p id="p1"><a id="a1">This <a id="a1-1">' .
   'is paragraph <a id="a1-2">1.</a></a></a></p>',
   'HTML p1 content');

is(xml(scalar $html->look_down(id=>'p4')),
   '<p id="p4"><a id="a4">This is paragraph 4<br /> on two lines.</a></p>',
   'HTML p4 content');

#---------------------------------------------------------------------
done_testing;

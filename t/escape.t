#!/usr/bin/perl

# Tests that the following translations take place, and none other:
#
#  & => &#38; (aka &amp;)
#  < => &#60; (aka &lt;)
#  > => &#62; (aka &gt;)
#  " => &#34; (aka &quot;)
#
# Further tests that already-escaped things are not further escaped.

BEGIN {
	%translations = (
		'x > 3'   => 'x &#62; 3',
		'x < 3'   => 'x &#60; 3',
		'< 3 >'   => '&#60; 3 &#62;',
		"he's"    => "he's",
		'"his"'   => '&#34;his&#34;',
		'“his”'   => '“his”', # MS "smart" quotes don't get escaped
		'1&2'     => '1&#38;2',
		'1&#38;2' => '1&#38;2',
		'1&amp;2' => '1&amp;2',
		'1&amp 2' => '1&#38;amp 2',
		'1&#38 2' => '1&#38;#38 2',
		'abc'     => 'abc',
		'número'  => 'número',
	);

	$tests = keys(%translations) + 1;
}

use Test::More tests => $tests;

BEGIN {

	use_ok('HTML::Element');
}

foreach my $orig (keys %translations) {
	$new = $orig;
	HTML::Element::_xml_escape($new);
	is($new,$translations{$orig},"Properly escaped: $orig");
}

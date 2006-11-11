#!/usr/bin/perl

# Tests that the following translations take place, and none other:
#
#  & => &#38; (aka &amp;)
#  < => &#60; (aka &lt;)
#  > => &#62; (aka &gt;)
#  ' => &#39; (aka &apos;)
#  " => &#34; (aka &quot;)
#
# Further tests that already-escaped things are not further escaped.
#
# Escapes are defined in the XML spec:
#    http://www.w3.org/TR/2006/REC-xml11-20060816/#dt-escape


BEGIN {
	%translations = (
		'x > 3'   => 'x &#62; 3',
		'x < 3'   => 'x &#60; 3',
		'< 3 >'   => '&#60; 3 &#62;',
		"he's"    => "he&#39;s",
		"he’s"    => "he’s", # MS "smart" quotes don't get escaped (single)
		'"his"'   => '&#34;his&#34;',
		'‘his’'   => '‘his’', # MS "smart" quotes don't get escaped (single)
		'“his”'   => '“his”', # MS "smart" quotes don't get escaped (double)
		'1&2'     => '1&#38;2',
		'1&#38;2' => '1&#38;2',
		'1&amp;2' => '1&amp;2',
		'1&amp 2' => '1&#38;amp 2',
		'1&#38 2' => '1&#38;#38 2',
		'abc'     => 'abc',
		'número'  => 'número',
		'&dArr;'  => '&dArr;',
		'&OElig;' => '&OElig;',
		'&sup2;'  => '&sup2;',
		'&no_go;' => '&#38;no_go;',

		'This &#x17f;oftware has &#383;ome bugs' => 'This &#x17f;oftware has &#383;ome bugs', # RT 18568
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


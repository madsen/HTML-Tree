#!/usr/bin/perl

use warnings;
use strict;

use Test::More tests => 8;

BEGIN {
	use_ok('HTML::TreeBuilder');
}

EMPTY: {
	my $root = HTML::TreeBuilder->new();
	$root->implicit_body_p_tag(1);
	$root->xml_mode(1);
	$root->parse('');
	$root->eof();

	is($root->as_HTML(),"<html><head></head><body></body></html>\n");
}

BR_ONLY: {
	my $root = HTML::TreeBuilder->new();
	$root->implicit_body_p_tag(1);
	$root->xml_mode(1);
	$root->parse('<br />');
	$root->eof();

	is($root->as_HTML(),"<html><head></head><body><p><br /></body></html>\n");
}

TEXT_ONLY: {
	my $root = HTML::TreeBuilder->new();
	$root->implicit_body_p_tag(1);
	$root->xml_mode(1);
	$root->parse('text');
	$root->eof();

	is($root->as_HTML(),"<html><head></head><body><p>text</body></html>\n");
}

EMPTY_TABLE: {
	my $root = HTML::TreeBuilder->new();
	$root->implicit_body_p_tag(1);
	$root->xml_mode(1);
	$root->parse('<table></table>');
	$root->eof();

	is($root->as_HTML(),"<html><head></head><body><table></table></body></html>\n");
}

ESCAPES: {
	my $root = HTML::TreeBuilder->new();
	my $escape = 'This &#x17f;oftware has &#383;ome bugs';
	my $html = $root->parse($escape)->eof->elementify();
	TODO: {
		local $TODO = 'HTML::Parser::parse mucks with our escapes';
		is($html->as_HTML(),"<html><head></head><body>$escape</body></html>\n");
	}
}

OTHER_LANGUAGES: {
	my $root = HTML::TreeBuilder->new();
	my $escape = 'Geb&uuml;hr vor Ort von &euro; 30,- pro Woche'; # RT 14212
	my $html = $root->parse($escape)->eof;
	is($html->as_HTML(),"<html><head></head><body>Geb&uuml;hr vor Ort von &euro; 30,- pro Woche</body></html>\n");
}

RT_18570: {
	my $root = HTML::TreeBuilder->new();
	my $escape = 'This &sim; is a twiddle';
	my $html = $root->parse($escape)->eof->elementify();
	is($html->as_HTML(),"<html><head></head><body>$escape</body></html>\n");
}

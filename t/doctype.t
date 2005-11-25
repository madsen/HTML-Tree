#!perl -Tw

use strict;
use Test::More tests => 2;

BEGIN {
    use_ok( "HTML::TreeBuilder" );
}

my $html =<<'EOHTML';
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
</head>
<body>
blah blah
</body>
</html>
EOHTML

my $tree = HTML::TreeBuilder->new;


$tree->parse($html);
$tree->eof;

my $text = $tree->as_HTML(undef, " ");
my @lines = split( "\n", $text );

like( $lines[0], qr/DOCTYPE/, "DOCTYPE is in the first line" );

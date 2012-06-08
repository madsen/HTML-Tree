#! /usr/bin/perl
#---------------------------------------------------------------------
# encoding.t
#
# Test automatic encoding detection for parse_file
#---------------------------------------------------------------------

use strict;
use warnings;

use Test::More;

use Encode qw(find_encoding);
use HTML::TreeBuilder;

my @encodings = qw(
    cp1252
    utf-8-strict
    utf-8-strict:BOM
    UTF-16BE:BOM
    UTF-16LE:BOM
);

plan tests => 5 * @encodings;

my $tempfile = "lwp-test-$$";

foreach my $encoding (@encodings) {
    my ($layer, $bom) = split /:/, $encoding;

    my $charset = find_encoding($layer)->mime_name;

    open(my $out, ">:encoding($layer)", $tempfile)
        or die "Can't open $tempfile ($layer): $!";

    my $mdash = ($layer =~ /^utf/i ? "\x{2014}" : "&mdash;");

    print $out "\x{FeFF}" if $bom;
    print $out <<"END HTML";
<!DOCTYPE html>
<html>
<head>
<meta charset="$charset">
<title>Test File</title>
</head>
<body>
<p>This is nbsp:\xA0&nbsp;</p>
<p>This is e-acute: \xE9&eacute;</p>
<p>This is mdash: $mdash&mdash;</p>
</body>
</html>
END HTML

    close $out;

    my $html = HTML::TreeBuilder->new_from_file($tempfile);

    isa_ok($html, 'HTML::TreeBuilder', "$encoding loaded");

    is($html->encoding, $encoding, "$encoding encoding");

    my @p = $html->look_down(qw(_tag p));

    is($p[0]->as_text, "This is nbsp:\xA0\xA0", "$encoding p0");
    is($p[1]->as_text, "This is e-acute: \xE9\xE9", "$encoding p1");
    is($p[2]->as_text, "This is mdash: \x{2014}\x{2014}", "$encoding p2");
}

unlink($tempfile);

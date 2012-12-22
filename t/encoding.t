#! /usr/bin/perl
#---------------------------------------------------------------------
# encoding.t
#
# Test automatic encoding detection for parse_file
#---------------------------------------------------------------------

use 5.008;
use strict;
use warnings;
use utf8;

use Test::More 0.88;            # done_testing
use t::Util qw(slurp text);

use Encode qw(encode find_encoding);
use HTML::TreeBuilder;

my @encodings = qw(
    cp1252
    utf-8-strict
    utf-8-strict:BOM
    UTF-16BE:BOM
    UTF-16LE:BOM
);

plan tests => 22 + 6 * @encodings;

my $tempfile = "lwp-test-$$";

SKIP: {
    skip("Encode 2.21 needed for these tests", 6 * @encodings)
        unless eval { Encode->VERSION(2.21); 1 }; # need mime_name

    foreach my $encoding (@encodings) {
        my ($layer, $bom) = split /:/, $encoding;

        my $charset = find_encoding($layer)->mime_name;

        open(my $out, ">:raw:encoding($layer)", $tempfile)
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

        my $text = "Hello: é—World\n";

        $out = $html->openw($tempfile);
        print $out $text;
        close $out;

        $text = "\x{FeFF}$text" if $bom;

        is(slurp($tempfile), encode($layer, $text),
           "Correct output for $encoding");
    }
} # end SKIP unless Encode 2.21

#---------------------------------------------------------------------
# Try reading t/sample.html in various ways:

my $test_fn = 't/sample.html';

{ # Auto-detect encoding:
    my $html = HTML::TreeBuilder->new_from_file($test_fn);

    is(text(nbsp   => $html), 'This is nbsp:  ',     'auto-detect nbsp');
    is(text(eacute => $html), 'This is e-acute: éé', 'auto-detect eacute');
    is(text(mdash  => $html), 'This is mdash: ——',   'auto-detect mdash');
}

{ # Explicitly specify correct encoding:
    my $html = HTML::TreeBuilder->new_from_file($test_fn, encoding => 'UTF-8');

    is(text(nbsp   => $html), 'This is nbsp:  ',     'UTF-8 nbsp');
    is(text(eacute => $html), 'This is e-acute: éé', 'UTF-8 eacute');
    is(text(mdash  => $html), 'This is mdash: ——',   'UTF-8 mdash');
}

{ # Explicitly specify incorrect encoding:
    my $html = HTML::TreeBuilder->new_from_file($test_fn,
                                                encoding => 'latin-1');


    is(text(nbsp   => $html), "This is nbsp:\xC2\xA0\xA0",       'latin-1 nbsp');
    is(text(eacute => $html), "This is e-acute: \xC3\xA9\xE9",   'latin-1 eacute');
    is(text(mdash  => $html), "This is mdash: \xE2\x80\x94\x{2014}", 'latin-1 mdash');
}

{ # Explicitly specify :raw encoding:
    local $^W; # Make HTML::Parser shut up; we're doing it wrong on purpose
    my $html = HTML::TreeBuilder->new_from_file($test_fn, encoding => '');

    is(text(nbsp   => $html), "This is nbsp:\xC2\xA0\xA0",       'raw nbsp');
    is(text(eacute => $html), "This is e-acute: \xC3\xA9\xE9",   'raw eacute');
    is(text(mdash  => $html), "This is mdash: \xE2\x80\x94\x{2014}", 'raw mdash');
}

{ # Set correct encoding as default:
    local $HTML::Element::default_encoding = 'UTF-8';
    my $html = HTML::TreeBuilder->new_from_file($test_fn);

    is(text(nbsp   => $html), 'This is nbsp:  ',     'default UTF-8 nbsp');
    is(text(eacute => $html), 'This is e-acute: éé', 'default UTF-8 eacute');
    is(text(mdash  => $html), 'This is mdash: ——',   'default UTF-8 mdash');
}

{ # Set incorrect encoding as default:
    local $HTML::Element::default_encoding = 'latin-1';
    my $html = HTML::TreeBuilder->new_from_file($test_fn);

    is(text(nbsp   => $html), "This is nbsp:\xC2\xA0\xA0",
       'default latin-1 nbsp');
    is(text(eacute => $html), "This is e-acute: \xC3\xA9\xE9",
       'default latin-1 eacute');
    is(text(mdash  => $html), "This is mdash: \xE2\x80\x94\x{2014}",
       'default latin-1 mdash');
}

{ # Set :raw encoding as default:
    local $^W; # Make HTML::Parser shut up; we're doing it wrong on purpose
    local $HTML::Element::default_encoding = '';
    my $html = HTML::TreeBuilder->new_from_file($test_fn);

    is(text(nbsp   => $html), "This is nbsp:\xC2\xA0\xA0",
       'default raw nbsp');
    is(text(eacute => $html), "This is e-acute: \xC3\xA9\xE9",
       'default raw eacute');
    is(text(mdash  => $html), "This is mdash: \xE2\x80\x94\x{2014}",
       'default raw mdash');
}

{ # Try applying :crlf to filehandle returned by openw
    my $out = HTML::Element->openw($tempfile, 'UTF-16LE:BOM');

    binmode $out, ':crlf';

    my $text = "Hello, world\nLine 2\n";

    print $out $text;

    close $out;

    $text = "\x{FeFF}$text";
    $text =~ s/\n/\r\n/g;

    is(slurp($tempfile), encode('UTF-16LE', $text),
       "Applying :crlf after openw works");
}

unlink($tempfile);

done_testing;

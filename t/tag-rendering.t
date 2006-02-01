#!perl -w

use Test::More tests => 8;
use strict;

BEGIN {
    use_ok( "HTML::Element" );
}


my $img =
    HTML::Element->new( 'img', (
        src => 'damian-conway-in-a-dress.jpg',
        height=>540, width=>100, border=>0,
        alt => "A few bottles of Chech'tluth later...",
    ) );

my $href = '/report/fullcsv';
my $literal_href = HTML::Element->new(
  '~literal', 'text' => "window.location.href='$href'"
 );
$img->attr(onClick => $literal_href);




isa_ok( $img, 'HTML::Element' );
my $html = $img->as_HTML;
print $html, "\n";

like( $html, qr/<img .+ \/>/,    "Tag is self-closed" );
like( $html, qr/ height="540" /, "Height is quoted" );
like( $html, qr/ border="0" /,   "Border is quoted" );
like( $html, qr/ width="100" /,  "Width is quoted" );
like( 
  $html, 
  qr! onclick="window.location.href='$href'!,
  "Literal text is preserved" 
 );
like( $html, qr/ alt="A few bottles of Chech&#39;tluth later..." /, "Alt tag is quoted and escaped" );

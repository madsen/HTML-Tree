

# -*-Perl-*-
# Time-stamp: "2003-09-15 01:45:31 ADT"
BEGIN { print "1..1\n"; }

use HTML::Parse;

print "#Using HTML::TreeBuilder version v$HTML::TreeBuilder::VERSION\n";
print "#Using HTML::Element version v$HTML::Element::VERSION\n";
print "#Using HTML::Parser version v", $HTML::Parser::VERSION || "?", "\n";
print "#Using HTML::Entities version v", $HTML::Entities::VERSION || "?", "\n";
print "#Using HTML::Tagset version v", $HTML::Tagset::VERSION || "?", "\n";
print "# Running under perl version $] for $^O",
  (chr(65) eq 'A') ? "\n" : " in a non-ASCII world\n";
print "# Win32::BuildNumber ", &Win32::BuildNumber(), "\n"
  if defined(&Win32::BuildNumber) and defined &Win32::BuildNumber();
print "# MacPerl verison $MacPerl::Version\n"
  if defined $MacPerl::Version;
printf 
  "# Current time local: %s\n# Current time GMT:   %s\n",
  scalar(localtime($^T)), scalar(gmtime($^T));


# This is a very simple test.  It basically just ensures that the
# HTML::Parse module is parsed ok by perl.

$HTML = <<'EOT';

<Title>Test page
</title>

<h1>Header</h1>

This is a link to
<a href="http://www.sn.no/">Schibsted</a> <b>Nett</b> in Norway.

<p>Sofie Amundsen var på vei hjem fra skolen.  Det første stykket
hadde hun gått sammen med Jorunn.  De hadde snakket om roboter.
Jorunn hadde ment at menneskets hjerne var som en komplisert
datamaskin.  Sofie var ikke helt sikker på om hun var enig.  Et
menneske m&aring;tte da være noe mer enn en maskin?


<!-- This is

a <strong>comment</strong>

<!--

-->  <-- this one did not terminate the comment
         because "--" on the previous line

more comment

-->

<p>
<table>
<tr><th colspan=2>Name
<tr><td>Aas<td>Gisle
<tr><td>Koster<td>Martijn
</table>

EOT


$h = parse_html $HTML;

# This ensures that the output from $h->dump goes to STDOUT

$html = $h->as_HTML(undef, '  ');

{
 my $h = $html;
 $h =~ s/^/\# /mg;
 print "# HTML: $h#\n";
}

# This is a very simple test just to ensure that we get something
# sensible back.
if( $html =~ /<BODY>/i && $html =~ /www\.sn\.no/
	         && $html !~ /comment/ && $html =~ /Gisle/
) {
  print "ok 1\n\n";
} else {
  print "not ok 1\n\n";
}

$h->delete;


exit;

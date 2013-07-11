package HTML::Parse;

use 5.008;

#ABSTRACT: Deprecated, a wrapper around HTML::TreeBuilder

=head1 SYNOPSIS

  See the documentation for HTML::TreeBuilder

=head1 DESCRIPTION

Disclaimer: This module is provided only for backwards compatibility
with earlier versions of this library.  New code should I<not> use
this module, and should really use the HTML::Parser and
HTML::TreeBuilder modules directly, instead.

The C<HTML::Parse> module provides functions to parse HTML documents.
There are two functions exported by this module:

=over 4

=item parse_html($html) or parse_html($html, $obj)

This function is really just a synonym for $obj->parse($html) and $obj
is assumed to be a subclass of C<HTML::Parser>.  Refer to
L<HTML::Parser> for more documentation.

If $obj is not specified, the $obj will default to an internally
created new C<HTML::TreeBuilder> object configured with strict_comment()
turned on.  That class implements a parser that builds (and is) a HTML
syntax tree with HTML::Element objects as nodes.

The return value from parse_html() is $obj.

=item parse_htmlfile($file, [$obj])

Same as parse_html(), but pulls the HTML to parse, from the named file.

Returns C<undef> if the file could not be opened, or $obj otherwise.

=back

When a C<HTML::TreeBuilder> object is created, the following variables
control how parsing takes place:

=over 4

=item $HTML::Parse::IMPLICIT_TAGS

Setting this variable to true will instruct the parser to try to
deduce implicit elements and implicit end tags.  If this variable is
false you get a parse tree that just reflects the text as it stands.
Might be useful for quick & dirty parsing.  Default is true.

Implicit elements have the implicit() attribute set.

=item $HTML::Parse::IGNORE_UNKNOWN

This variable controls whether unknown tags should be represented as
elements in the parse tree.  Default is true.

=item $HTML::Parse::IGNORE_TEXT

Do not represent the text content of elements.  This saves space if
all you want is to examine the structure of the document.  Default is
false.

=item $HTML::Parse::WARN

Call warn() with an appropriate message for syntax errors.  Default is
false.

=back

=head1 REMEMBER!

HTML::TreeBuilder objects should be explicitly destroyed when you're
finished with them.  See L<HTML::TreeBuilder>.

=head1 SEE ALSO

L<HTML::Parser>, L<HTML::TreeBuilder>, L<HTML::Element>

=cut

use warnings;
use strict;

# VERSION from OurPkgVersion

require Exporter;
our @ISA    = qw(Exporter);
our @EXPORT = qw(parse_html parse_htmlfile);

# Backwards compatibility
our $IMPLICIT_TAGS  = 1;
our $IGNORE_UNKNOWN = 1;
our $IGNORE_TEXT    = 0;
our $WARN           = 0;

require HTML::TreeBuilder;

sub parse_html {
    my $p = $_[1];
    $p = _new_tree_maker() unless $p;
    $p->parse( $_[0] );
}

sub parse_htmlfile {
    my ( $file, $p ) = @_;
    my ($HTML);
    open( $HTML, "<", $file ) or return;
    $p = _new_tree_maker() unless $p;
    $p->parse_file($HTML);
}

sub _new_tree_maker {
    my $p = HTML::TreeBuilder->new(
        implicit_tags  => $IMPLICIT_TAGS,
        ignore_unknown => $IGNORE_UNKNOWN,
        ignore_text    => $IGNORE_TEXT,
        'warn'         => $WARN,
    );
    $p->strict_comment(1);
    $p;
}

1;

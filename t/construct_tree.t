#!perl -Tw
use Test::More tests => (3 + 7 * 8);
#initial tests + number of tests in test_new_obj() * number of times called

use strict;

BEGIN {
    use_ok( 'HTML::Tree' );
}

my $obj = new HTML::Tree;

isa_ok($obj, "HTML::TreeBuilder");

our $TestInput = "t/oldparse.html";

my $HTML ;
{
    local $/ = undef ;
    open(INFILE, $TestInput) || die "Can't open $TestInput: $!";
    $HTML=<INFILE> ;
    close(INFILE) ;
}

# setup some parts of the HTML for the list tests.

# die "$TestInput does not have at least 2 characters!"
#     if length($HTML) <= 2;
# my $HTMLPart1 = substr( $HTML, 0, int( length($HTML) / 2 ) );
# my $HTMLPart2 = substr( $HTML, int( length($HTML) / 2 ) );

# The logic here is to try to split the HTML in the middle of a tag.
# The above commented-out code is also an option.

my $split_at = 4;
die "$TestInput does not have at least " . ($split_at + 1) . " characters!"
    if length($HTML) <= $split_at;
my $HTMLPart1 = substr( $HTML, 0, 4 );
my $HTMLPart2 = substr( $HTML, 4 );

is($HTMLPart1 . $HTMLPart2, $HTML, "split \$HTML correctly"); 


# Filehandle Test
{
    open(INFILE, $TestInput) || die "Can't open $TestInput: $!";
    my $file_obj    = HTML::Tree->new_from_file( *INFILE );
    test_new_obj($file_obj, "new_from_file Filehandle" ) ;
    close(INFILE);
}


# Scalar Tests
{
    my $content_obj = HTML::Tree->new_from_content($HTML);
    test_new_obj($content_obj, "new_from_content Scalar") ;
}

{
    my $file_obj    = HTML::Tree->new_from_file( $TestInput);
    test_new_obj($file_obj, "new_from_file Scalar" ) ;
}

{
    my $parse_content_obj = HTML::Tree->new;
    $parse_content_obj->parse_content( $HTML);
    test_new_obj($parse_content_obj, "new(); parse_content Scalar" );
}


# Scalar REF Tests
{
    my $content_obj = HTML::Tree->new_from_content($HTML);
    test_new_obj($content_obj, "new_from_content Scalar REF") ;
}

# None for new_from_file
# Filehandle test instead. (see above)

{
    my $parse_content_obj = HTML::Tree->new;
    $parse_content_obj->parse_content( $HTML);
    test_new_obj($parse_content_obj, "new(); parse_content Scalar REF" );
}


# List Tests (Scalar and Scalar REF)
{
    my $content_obj = HTML::Tree->new_from_content(\$HTMLPart1, $HTMLPart2);
    test_new_obj($content_obj, "new_from_content List") ;
}

# None for new_from_file.
# Does not support lists.

{
    my $parse_content_obj = HTML::Tree->new;
    $parse_content_obj->parse_content( \$HTMLPart1, $HTMLPart2 );
    test_new_obj($parse_content_obj, "new(); parse_content List");
}


sub test_new_obj {

    my $obj = shift ;
    my $test_description = shift;

    isa_ok($obj, "HTML::TreeBuilder", $test_description);

    my $html;
    ok ($html = $obj->as_HTML(undef, '  '), "Get html as string." );

    # This is a very simple test just to ensure that we get something
    # sensible back.
    like( $html, qr/<BODY>/i, "<BODY> found OK." );
    like( $html, qr/www\.sn\.no/, "found www.sn.no link" );

    TODO: {
        local $TODO = <<ENDTEXT;
HTML::Parser doesn't handle nested comments correctly.
See: http://phalanx.kwiki.org/index.cgi?HTMLTreeNestedComments
ENDTEXT

        unlike( $html, qr/nested-comment/, "Nested comment not found" );
    }

    unlike( $html, qr/simple-comment/, "Simple comment not found" );
    like( $html, qr/Gisle/, "found Gisle" );

}

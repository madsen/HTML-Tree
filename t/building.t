#!perl -Tw

# -*-Perl-*-
# Time-stamp: "2003-09-15 01:45:47 ADT"

#Test that we can build and compare trees

use Test::More tests=>40;
use strict;

BEGIN {
    use_ok( "HTML::Element", 1.53 );
}

#; diag "Using HTML::Element version v&HTML::Element::Version()\n";
#; diag "Using HTML::Parser version v", $HTML::Parser::VERSION || "?", "\n";
#; diag "Using HTML::Entities version v", $HTML::Entities::VERSION || "?", "\n";
#; diag "Using HTML::Tagset version v", $HTML::Tagset::VERSION || "?", "\n";
#; diag "Running under perl version $] for $^O",
#;   (chr(65) eq 'A') ? "\n" : " in a non-ASCII world\n";
#; diag " Win32::BuildNumber ", &Win32::BuildNumber(), "\n"
#;   if defined(&Win32::BuildNumber) and defined &Win32::BuildNumber();
#; diag "MacPerl verison $MacPerl::Version\n"
#;   if defined $MacPerl::Version;
#; diag sprintf
#;   "Current time local: %s\nCurrent time GMT:   %s\n",
#;   scalar(localtime($^T)), scalar(gmtime($^T));

### test subroutine by comparing to variable that it is supposed to return.  This test may be questionable???
is($HTML::Element::VERSION, &HTML::Element::Version(), "Version Subroutine") ;

FIRST_BLOCK: {
  my $lol =
     ['html',
      ['head',
       [ 'title', 'I like stuff!' ],
      ],
      ['body',
       {'lang', 'en-JP'},
       'stuff',
                 ['p', 'um, p < 4!', {'class' => 'par123'}],
       ['div', {foo => 'bar'}, ' 1  2  3 '],  # at 0.1.2
       ['hr'],
      ]
     ]
  ;
  my $t1 = HTML::Element->new_from_lol( $lol );
  isa_ok( $t1, 'HTML::Element' );

	### added to test ->is_empty() and ->look_up()
	my $hr = $t1->find('hr') ;
	isa_ok( $hr, 'HTML::Element' );
	ok($hr->is_empty(), "testing is_empty method on <hr> tag") ;
	my $lookuptag = $hr->look_up("_tag", "body") ;
	is('<body lang="en-JP">', $lookuptag->starttag(), "verify hr->look_up found body tag") ;
	my %attrs = $lookuptag->all_attr() ;
	my @attrs1 = sort keys %attrs ;
	my @attrs2 = sort $lookuptag->all_attr_names() ;
	is_deeply( \@attrs1, \@attrs2, "is_deeply attrs") ;
#	print join(":", keys %attrs) ;
#	print "##########" ;
#	print join(":", @attrs) ;


  # Test scalar context
  my $count = $t1->content_list;
  is( $count, 2, "Works in scalar" );

  # Test list context
  my @list = $t1->content_list;
  is( scalar @list, 2, "Should get two items back" );
  isa_ok( $list[0], 'HTML::Element' );
  isa_ok( $list[1], 'HTML::Element' );

  my $div = $t1->find_by_attribute('foo','bar');
  isa_ok( $div, 'HTML::Element' );

	### tests of various output formats
#	print "# ", $div->as_text(), "\n" ;
#	print "# ", $div->as_trimmed_text(), "\n" ;
#	print "# ", $div->as_Lisp_form(), "\n" ;
	is( $div->as_text()," 1  2  3 ", "Dump element in text format");
	is( $div->as_trimmed_text(),"1 2 3", "Dump element in trimmed text format");
	is( $div->as_text_trimmed(),"1 2 3", "Dump element in trimmed text format");
	is( $div->as_Lisp_form(),"(\"_tag\" \"div\" \"foo\" \"bar\" \"_content\" (\n  \" 1  2  3 \"))\n", "Dump element as Lisp form");

  is( $div->address, '0.1.2' );
  is( $div, $t1->address('0.1.2'), 'using address to get the node' );
  ok( $div->same_as($div) );
  ok( $t1->same_as($t1) );
  ok( not($div->same_as($t1)) );

  my $t2 = HTML::Element->new_from_lol($lol);
  isa_ok( $t2, 'HTML::Element' );
  ok( $t2->same_as($t1) );
  $t2->address('0.1.2')->attr('snap', 123);
  ok( not($t2->same_as($t1)) );

  my $body = $t1->find_by_tag_name('body');
  isa_ok( $body, 'HTML::Element' );
  is( $body->tag, 'body' );

  my $cl = join '~', $body->content_list;
  my @detached = $body->detach_content;
  is( $cl, join '~', @detached );
  $body->push_content(@detached);
  is( $cl, join '~', $body->content_list );

  $t2->delete;
  $t1->delete;
}

Test2: # for normalization
{
  my $t1 = HTML::Element->new_from_lol(['p', 'stuff', ['hr'], 'thing']);
  my @start = $t1->content_list;
  is( scalar(@start), 3 );
  my $lr = $t1->content;
  # $lr is ['stuff', HTML::Element('hr'), 'thing']
  is( $lr->[0], 'stuff' );
  isa_ok( $lr->[1], 'HTML::Element' );
  is( $lr->[2], 'thing' );
  # insert some undefs
  splice @$lr,1,0, undef; # insert an undef between [0] and [1]
  push @$lr, undef;       # append an undef to the end
  unshift @$lr, undef;    # prepend an undef to the front
  # $lr is [undef, 'stuff', undef, H::E('hr'), 'thing', undef]

  Unnormalized: {
    #print "Content list:", join(',', map defined($_) ? $_ : '<UNDEF>', @$lr), "\n";
    my $cl_count = $t1->content_list;
    my @cl = $t1->content_list;
    is( $cl_count, 6 );
    is( scalar(@cl), $cl_count ); # also == 6
    { no warnings; # content_list contains undefs
      isnt( join('~', @start), join('~', $t1->content_list) );
    }
  }

  Normalized: {
    $t1->normalize_content;
    #print "Content list:", join(',', map defined($_) ? $_ : '<UNDEF>', @$lr), "\n";
    my @cl = $t1->content_list;
    eq_array( \@start, \@cl );
  }

  ok( not defined( $t1->attr('foo') ) );
  $t1->attr('foo', 'bar');
  is( $t1->attr('foo'), 'bar' );
  ok( scalar( grep( 'bar', $t1->all_external_attr() ) ) );
  $t1->attr('foo', '');
  ok( scalar( grep( 'bar', $t1->all_external_attr() ) ) );
  $t1->attr('foo', undef); # should delete it
  ok( not grep( 'bar', $t1->all_external_attr() ) );
  $t1->delete;
}

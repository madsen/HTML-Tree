#! /usr/bin/perl
#---------------------------------------------------------------------
# Copyright 2013 Christopher J. Madsen
#
# Author: Christopher J. Madsen <perl@cjmweb.net>
# Created: 1 Mar 2013
#
# This program is free software; you can redistribute it and/or modify
# it under the same terms as Perl itself.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See either the
# GNU General Public License or the Artistic License for more details.
#
# Test parsing and dumping various HTML chunks
#---------------------------------------------------------------------

use 5.008;
use strict;
use warnings;

use Test::More 0.88;            # want done_testing

# SUGGEST PREREQ: Test::Differences 0 (better output for failures)
# Load Test::Differences, if available:
BEGIN {
  if (eval "use Test::Differences; 1") {
    # Not all versions of Test::Differences support changing the style:
    eval { Test::Differences::unified_diff() }
  } else {
    *eq_or_diff = \&is;         # Just use "is" instead
  }
} # end BEGIN

use HTML::TreeBuilder 5.900 -weak;

#=====================================================================
my $generateResults;

if (@ARGV and $ARGV[0] eq 'gen') {
  # Just output the actual results, so they can be diffed against this file
  $generateResults = 1;
  open(OUT, '>', '/tmp/dump.t') or die $!;
  printf OUT "#%s\n\n__DATA__\n", '=' x 69;
} else {
  plan tests => 12;
}

my %empty_hash;

while (<DATA>) {
  print OUT $_ if $generateResults;

  next if /^#[^#]/ or not /\S/;

  /^##\s*(.+)/ or die "Expected test name, got $_";
  my $name = $1;

  # Read the constructor parameters:
  my $param = '';
  while (<DATA>) {
    print OUT $_ if $generateResults;
    last if $_ eq "<<'---END---';\n";
    $param .= $_;
  } # end while <DATA>

  die "Expected <<'---END---';" unless defined $_;

  # Read the input:
  my $input = '';
  while (<DATA>) {
    print OUT $_ if $generateResults;
    last if $_ eq "---OUT---\n";
    $input .= $_;
  }

  die "Expected ---OUT---" unless defined $_;

  # Read the expected results:
  my $expected = '';
  while (<DATA>) {
    last if $_ eq "---END---\n";
    $expected .= $_;
  }

  # Run the test:
  my $hash = $param ? eval $param : \%empty_hash;
  die $@ unless ref $hash;

  my $tree = HTML::TreeBuilder->new_from_string($input, %$hash);
  isa_ok($tree, 'HTML::Element', $name) unless $generateResults;

  open(my $mem, '>', \(my $got)) or die;

  $tree->dump($mem);

  # Either print the actual results, or compare to expected results:
  if ($generateResults) {
    print OUT "$got---END---\n";
  } else {
    eq_or_diff($got, $expected, "$name output");
  }
} # end while <DATA>

done_testing unless $generateResults;

#=====================================================================

__DATA__

## basic HTML 4.01
<<'---END---';
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
        "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Title</title>
</head>
<body></body>
</html>
---OUT---
<html> @0
  <head> @0.0
    <title> @0.0.0
      "Title"
  <body> @0.1
---END---

## simple but missing tags
<<'---END---';
<html><p>Some text
---OUT---
<html> @0
  <head> @0.0 (IMPLICIT)
  <body> @0.1 (IMPLICIT)
    <p> @0.1.0
      "Some text "
---END---

## no end tags
<<'---END---';
<h1>Head1
<p>Para1
<h2>Head2
<p>Para2
<h3>Head3
<p>Para3
---OUT---
<html> @0 (IMPLICIT)
  <head> @0.0 (IMPLICIT)
  <body> @0.1 (IMPLICIT)
    <h1> @0.1.0
      "Head1 "
    <p> @0.1.1
      "Para1 "
    <h2> @0.1.2
      "Head2 "
    <p> @0.1.3
      "Para2 "
    <h3> @0.1.4
      "Head3 "
    <p> @0.1.5
      "Para3 "
---END---

## RT83641 - <link> in <form>
<<'---END---';
<html><head><title>Title</title></head><body>
<form>
<p>Before</p>
<link>
<div>After</div>
</form>
<span>Outside</span>
</body>
</html>
---OUT---
<html> @0
  <head> @0.0
    <title> @0.0.0
      "Title"
    <link /> @0.0.1
  <body> @0.1
    <form> @0.1.0
      <p> @0.1.0.0
        "Before"
    <div> @0.1.1
      "After"
    <span> @0.1.2
      "Outside"
---END---

## RT83641 with implicit_tags 0
{
  implicit_tags => 0,
}
<<'---END---';
<html><head><title>Title</title></head><body>
<form>
<p>Before</p>
<link>
<div>After</div>
</form>
<span>Outside</span>
</body>
</html>
---OUT---
<html> @0 (IMPLICIT)
  <html> @0.0
    <head> @0.0.0
      <title> @0.0.0.0
        "Title"
    <body> @0.0.1
      <form> @0.0.1.0
        <p> @0.0.1.0.0
          "Before"
        <link /> @0.0.1.0.1
        <div> @0.0.1.0.2
          "After"
      <span> @0.0.1.1
        "Outside"
---END---

## RT76051
<<'---END---';
<div id="gallery-subcontent" class="module">
 <script language="javascript" src="ugc.js" type="text/javascript"></script>
 <meta http-equiv="Pragma" content="no-cache" />
 <meta http-equiv="Expires" content="0" />
 <meta http-equiv="Cache-Control" content="no-cache" />
 <a name="comment-form" id="comment-form" >
 </a>
 <!-- new display -->
 <div id="tugs_story_display">
---OUT---
<html> @0 (IMPLICIT)
  <head> @0.0 (IMPLICIT)
    <meta content="no-cache" http-equiv="Pragma" /> @0.0.0
    <meta content="0" http-equiv="Expires" /> @0.0.1
    <meta content="no-cache" http-equiv="Cache-Control" /> @0.0.2
  <body> @0.1 (IMPLICIT)
    <div class="module" id="gallery-subcontent"> @0.1.0
      <script language="javascript" src="ugc.js" type="text/javascript"> @0.1.0.0
    <a id="comment-form" name="comment-form"> @0.1.1
      " "
    <div id="tugs_story_display"> @0.1.2
---END---

# Local Variables:
# compile-command: "perl dump.t gen"
# End:

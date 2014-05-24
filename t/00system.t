#!/usr/bin/perl -T

use warnings;
use strict;
use Test::More tests => 2;

BEGIN {
    use_ok('HTML::TreeBuilder');
    use_ok('HTML::Element');
}

diag "Running under perl version $] for $^O",
    ( chr(65) eq 'A' ) ? "" : " in a non-ASCII world";
diag "Using HTML::TreeBuilder version v$HTML::TreeBuilder::VERSION";
diag "Using HTML::Element version v$HTML::Element::VERSION";
diag "Using HTML::Parser version v", $HTML::Parser::VERSION || "?";
diag "Using HTML::Entities version v", $HTML::Entities::VERSION || "?";
diag "Using HTML::Tagset version v", $HTML::Tagset::VERSION || "?";
diag "Win32::BuildNumber ", &Win32::BuildNumber()
    if defined(&Win32::BuildNumber)
        and defined &Win32::BuildNumber();
diag "MacPerl verison $MacPerl::Version"
    if defined $MacPerl::Version;
diag "Current time local: " . localtime($^T);
diag "Current time GMT:   " . gmtime($^T);

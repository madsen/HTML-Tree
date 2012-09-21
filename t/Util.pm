#---------------------------------------------------------------------
package t::Util;
#
# Copyright 2012 Christopher J. Madsen
#
# Author: Christopher J. Madsen <perl@cjmweb.net>
# Created: 20 Sep 2012
#
# This program is free software; you can redistribute it and/or modify
# it under the same terms as Perl itself.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See either the
# GNU General Public License or the Artistic License for more details.
#
# ABSTRACT: Utility functions for testing HTML-Tree
#---------------------------------------------------------------------

use 5.008;
use strict;
use warnings;

use Exporter ();
our @ISA = qw(Exporter);
our @EXPORT = qw(xml);

#=====================================================================
# Convert an element to XML for testing:
#
# xml($elt);
# xml(id => $tree); # Finds element with id "id" in $tree

sub xml
{
    my $elt = shift;

    $elt = shift->look_down(id => $elt) unless ref $elt;

    return undef unless $elt;

    my $text = $elt->as_XML;

    $text =~ s/\s+\z//;         # Strip trailing whitespace

    $text;
} # end xml

#=====================================================================
# Package Return Value:

1;

__END__

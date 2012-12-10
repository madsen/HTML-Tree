HTML-Tree
=========

HTML-Tree is a suite of Perl modules for representing, creating, and extracting information from HTML syntax trees.

This is a Git repository where development of HTML-Tree takes place.  For more information, visit [HTML-Tree on CPAN](http://search.cpan.org/dist/HTML-Tree/).


How to build HTML-Tree from this repo
-------------------------------------

The files in this repository need to be processed through
[Dist::Zilla](http://dzil.org) in order to produce a distribution
suitable for uploading to CPAN or installing on your machine.  To do
that:

1. Install Dist::Zilla

        cpanm Dist::Zilla

2. Install the dzil plugins used by HTML-Tree

        cd /path/to/your/HTML-Tree
        dzil authordeps --missing | cpanm

This example uses [cpanm](http://search.cpan.org/perldoc?cpanm)
because it allows you to pipe a list of module names into it, but you
don't have to use cpanm if you prefer another method of installing modules.

Then you can build a distribution with `dzil build`, build a
distribution and run its tests with `dzil test`, or build a
distribution and automatically upload it to CPAN with `dzil release`.

To learn more about Dist::Zilla, read [its tutorial](http://dzil.org/tutorial/start.html).


Copyright and License
=====================

This software is copyright 1995-1998 Gisle Aas; 1999-2004 Sean M. Burke; 2005 Andy Lester; 2006 Pete Krawczyk; 2010 Jeff Fearn; 2012 Christopher J. Madsen (Except the articles contained in HTML::Tree::AboutObjects, HTML::Tree::AboutTrees, and HTML::Tree::Scanning, which are all copyright 2000 The Perl Journal.)

Except for those three TPJ articles, the whole HTML-Tree distribution is free software; you can redistribute it and/or modify it under the same terms as Perl itself.

Those three TPJ articles may be distributed under the same terms as Perl itself.

The programs in this library are distributed in the hope that they will be useful, but without any warranty; without even the implied warranty of merchantability or fitness for a particular purpose.

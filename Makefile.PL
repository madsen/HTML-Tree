require 5.004;
use ExtUtils::MakeMaker;
# Time-stamp: "2003-09-15 01:50:36 ADT"

WriteMakefile(
    'NAME'	   => 'HTML-Tree',
    'VERSION_FROM' => 'lib/HTML/Tree.pm', # finds $VERSION
    'PREREQ_PM'    => {	
	                 'HTML::Parser' => 2.19,   # at LEAST!
	                 'HTML::Tagset' => 3.02,
		      },
    'AUTHOR' => 'Sean M. Burke (sburke@cpan.org)',
    'ABSTRACT' => 'build and scan parse-trees of HTML',

    'dist'           => { COMPRESS => 'gzip -6f', SUFFIX => 'gz', },
);


package MY;

sub libscan
{ # Determine things that should *not* be installed
    my($self, $path) = @_;
    return '' if $path =~ m/~/;
    $path;
}

__END__

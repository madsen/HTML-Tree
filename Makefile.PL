require 5.004;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME            => 'HTML-Tree',
    VERSION_FROM    => 'lib/HTML/Tree.pm',
    PREREQ_PM       => {
        'HTML::Parser' => 3.46,
        'HTML::Tagset' => 3.02,
    },
    AUTHOR => 'Pete Krawczyk <petek@cpan.org>',
    ABSTRACT => 'build and scan parse-trees of HTML',

    dist            => { COMPRESS => 'gzip -9f', SUFFIX => 'gz' },
    clean           => { FILES => 'HTML-Tree-*' },
);

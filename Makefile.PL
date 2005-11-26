require 5.004;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME            => 'HTML-Tree',
    VERSION_FROM    => 'lib/HTML/Tree.pm',
    PREREQ_PM       => {
        'HTML::Parser' => 2.19,
        'HTML::Tagset' => 3.02,
    },
    AUTHOR => 'Andy Lester <andy@petdance.com>',
    ABSTRACT => 'build and scan parse-trees of HTML',

    dist            => { COMPRESS => 'gzip -9f', SUFFIX => 'gz' },
    clean           => { FILES => 'HTML-Tree-*' },
);

use 5.008;
use strict;
use warnings;
use inc::My_Build;

my $builder = inc::My_Build->new(
    module_name        => 'HTML::Tree',
    license            => 'perl',
    dist_author        => 'Christopher J. Madsen <perl@cjmweb.net>',
    dist_version_from  => 'lib/HTML/Element.pm',
##{ $plugin->get_prereqs ##}
    add_to_cleanup =>
        [ 'HTML-Tree-*', 'tmp', 'blib', 'lwp-test-*', 'MANIFEST.bak' ],
    script_files => 'bin',
);

$builder->create_build_script();

use strict;
use warnings;
use Module::Build;
use 5.008;

my $builder = Module::Build->new(
    module_name        => 'HTML::Tree',
    license            => 'perl',
    dist_author        => 'Christopher J. Madsen <perl@cjmweb.net>',
    dist_version_from  => 'lib/HTML/Element.pm',
##{ $plugin->get_prereqs ##}
    add_to_cleanup =>
        [ 'HTML-Tree-*', 'tmp', 'blib', 'lwp-test-*', 'MANIFEST.bak' ],
    script_files => ['htmltree'],
);

$builder->create_build_script();

use strict;
use warnings;
use Module::Build;
use 5.008;

my $class = Module::Build->subclass(
    class => 'My::Builder',
    code  => q{
    }
);

my $builder = $class->new(
    module_name       => 'HTML::Tree',
    license           => 'perl',
    dist_author       => 'Jeff Fearn <Jeff.Fearn@gmail.com>',
    dist_version_from => 'lib/HTML/Tree.pm',
	create_makefile_pl => 'traditional',
    build_requires    => {
        'Module::Build'       => 0,
        'Test::Exception'     => 0,
        'Test::More'          => 0,
        'HTML::Parser'        => 3.46,
        'HTML::Tagset'        => 3.02,
    },
    requires => {
        'HTML::Parser' => 3.46,
        'HTML::Tagset' => 3.02,
        'perl'         => '5.8.0',
    },
    add_to_cleanup => [ 'HTML-Tree-*', 'tmp', 'blib', 'lwp-test-*', 'MANIFEST.bak' ],
    script_files   => ['htmltree'],
);

$builder->create_build_script();

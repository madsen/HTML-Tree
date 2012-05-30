use strict;
use warnings;
use Module::Build;
use 5.008;

my $class = Module::Build->subclass(
    class => 'My::Builder',
    code  => q{
        sub ACTION_authortest {
            my ($self) = @_;
            $self->depends_on('build');
            $self->depends_on('manifest');
            $self->depends_on('distmeta');
            $self->test_files( qw< t xt/author > );
            $self->recursive_test_files(1);
            $self->depends_on('test');
            return;
        }
        sub ACTION_distdir {
            my ($self) = @_;
            $self->depends_on('authortest');
            return $self->SUPER::ACTION_distdir();
        }
    }
);

my $builder = $class->new(
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

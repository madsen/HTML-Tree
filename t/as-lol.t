#! /usr/bin/perl
#---------------------------------------------------------------------
# Test the as_lol & content_as_lol methods

use strict;
use warnings;

use Test::More 0.88;            # done_testing

use HTML::Element;

plan tests => 21;

#---------------------------------------------------------------------
sub t
{
    my ($name, $lol, $expected, $content_offset) = @_;

    # We trust new_from_lol here. This looks like cheating, but it isn't.
    my $tree = HTML::Element->new_from_lol($lol);

    isa_ok($tree, 'HTML::Element', $name);

    local $Test::Builder::Level = $Test::Builder::Level + 1;
    is_deeply($tree->as_lol(), $expected, "$name as_lol");

    # The content starts at $content_offset, extract those
    my @expected_content = @{$expected};
    splice(@expected_content, 0, $content_offset);

    # Compare deeply by wrapping in an arrayref - we've got lists, after all.
    is_deeply([$tree->content_as_lol()], [@expected_content], "$name content_as_lol");

} # end t

#---------------------------------------------------------------------

t('simple container',
    [p => 'Hello'],
    [p => 'Hello'],
1);
t('nested containers',
    [p => 'Hello', [b => ' World'], '!'],
    [p => 'Hello', [b => ' World'], '!'],
1);
t('with attributes',
    [p => 'Hello ', [a => { href => 'http://example.com', title => 'Example'}, 'example']],
    [p => 'Hello ', [a => { href => 'http://example.com', title => 'Example'}, 'example']],
1);
t('with top-level attributes',
    [p => 'Hello ', 'World', { class => 'example'}],
    [p => {class => 'example'}, 'Hello ', 'World'],
2);
t('with multiple top-level attributes',
    [p => 'Hello ', { class => 'example'}, [b => 'World'], {id => 'p-example'}],
    [p => {class => 'example', id => 'p-example'}, 'Hello ', [b => 'World']],
2);
t('empty',
    ['br'],
    ['br'],
1);
t('empty attributes',
    ['br', {}],
    ['br'],
1);
#---------------------------------------------------------------------
done_testing;

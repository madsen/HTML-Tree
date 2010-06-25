#!perl

if ( !require Test::Perl::Critic ) {
    Test::More::plan( skip_all =>
            "Test::Perl::Critic required for testing PBP compliance" );
}
else {
    Test::Perl::Critic->import(
        -verbose  => 8,
        -severity => 5,
## This check fails to detect a package is modifying
## objects of it's own class when passing objects in an array
        -exclude => ['ProhibitAccessOfPrivateData']
    );
}

Test::Perl::Critic::all_critic_ok();

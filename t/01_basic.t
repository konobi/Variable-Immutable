#!/usr/bin/env perl

use strict;
use warnings;

use Test::More tests => 30_000;
use Test::Exception;

Basic: {
    use_ok('Variable::Immutable');

    can_ok('Variable::Immutable', qw(make_immutable is_immutable));
}

Easy_failures: {
    throws_ok {
        Variable::Immutable::make_immutable();
    } qr{Must supply variable to make immutable}, q{Ensure die on no arguments};

    throws_ok {
        my $foo = 'haha';
        Variable::Immutable::make_immutable(\$foo);
    } qr{Must supply type constraint to use}, q{Ensure die on no TC};
}

Readonly: {
    my $foo = 'cookies on dowels!';

    Variable::Immutable::make_immutable(\$foo, 'Str');
    
    dies_ok {
        $foo = 'erple';
    } q{Ensure scalar has become read only};
}

Invalid_type_constraint: {
    my $foo = 'cookies on dowels!';

    throws_ok {
        Variable::Immutable::make_immutable(\$foo, 'hsjdhaskjdhaskjdhsk');
    } qr{Unable to locate type constraint}, q{Ensure we can find type constraint};
}

use Moose::Util::TypeConstraints;
Happy_day: {
    my $foo = 'bar';
  
    lives_ok {
        Variable::Immutable::make_immutable(\$foo, 'Str');
    } q{Ensure type constraint is valid};

    throws_ok {
        Variable::Immutable::make_immutable(\$foo, 'ArrayRef');
    } qr{Variable does not pass type constraint}, q{Ensure invalid value throws error};
}

Is_immutable: {
    my $foo = 'bar';
    Variable::Immutable::make_immutable(\$foo, 'Str');

    my $tc_orig = Moose::Util::TypeConstraints::find_type_constraint('Str');
    my $tc = Variable::Immutable::is_immutable(\$foo);

    is $tc, $tc_orig, q{is_immutable returns correct TC object};
}




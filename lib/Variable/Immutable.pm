package Variable::Immutable;

use strict;
use warnings;

use Scalar::Readonly;
use Scalar::Footnote;
use Moose::Util::TypeConstraints;

our $VERSION = '0.01_001';

sub make_immutable {
    my ($ref, $type_constraint) = @_;

    if(!ref($ref)){
        die "Must supply variable to make immutable";
    }

    if(!defined($type_constraint)){
        die "Must supply type constraint to use";
    }

    my $tc_object = Moose::Util::TypeConstraints::find_type_constraint($type_constraint);
    if(!$tc_object){
        die "Unable to locate type constraint";
    }

    if(!$tc_object->check($$ref)){
        die "Variable does not pass type constraint";
    }
    
    Scalar::Footnote::set($ref, '_moose_type_constraint' => $tc_object);
    Scalar::Readonly::readonly_on($$ref);
}

sub is_immutable {
    my ($ref) = @_;

    if(!Scalar::Readonly::readonly($$ref)){
        die "Value is not immutable";
    }

    my $note = Scalar::Footnote::get($ref, '_moose_type_constraint');
    if(!$note){
        die "Value is not immutable";
    }

    return $note;
}

1;

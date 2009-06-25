use inc::Module::Install;

name     'Variable::Immutable';
all_from 'lib/Variable/Immutable.pm';
author   'Scott McWhirter <konobi@cpan.org>';

build_requires 'Test::More';
build_requires 'Test::Exception';

requires 'Moose::Util::TypeConstraints';
requires 'Scalar::Readonly';
requires 'Scalar::Footnote';

license 'bsd';

auto_install;

WriteAll;

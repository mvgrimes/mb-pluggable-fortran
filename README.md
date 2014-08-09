# NAME

Module::Build::Pluggable::Fortran - Plugin for Module::Build to compile Fortran `.f` files

# VERSION

version 0.25

# SYNOPSIS

    # Build.PL
    use strict;
    use warnings;
    use Module::Build::Pluggable ('PDL');

    my $builder = Module::Build::Pluggable->new(
        dist_name  => 'PDL::My::Module',
        license    => 'perl',
        f_source   => [ 'src' ],
        requires   => { },
        configure_requires => {
            'Module::Build'                      => '0.4004',
            'Module::Build::Pluggable'           => '0',
            'Module::Build::Pluggable::Fortran'  => '0.20',
        },

    );
    $builder->create_build_script();

# DESCRIPTION

This is a plugin for [Module::Build](https://metacpan.org/pod/Module::Build) (using [Module::Build::Pluggable](https://metacpan.org/pod/Module::Build::Pluggable)) that
will assist in building distributions that require Fortran `.f` files to be
compiled. Please see the [Module::Build::Authoring](https://metacpan.org/pod/Module::Build::Authoring) documentation if you are
not familiar with it.

- Add Prerequisites

        build_requires => {
            'ExtUtils::F77'      => '0',
            'ExtUtils::CBuilder' => '0.23',
        },

    You can, or course, require your own versions of these modules by adding them
    to `requires =` {}> as usual.

- Compile `.f` files

    The `lib` directory of your distribution will be searched for `.f` files
    and, immediately prior to the build phase, compiles them into `.o` files.
    This is accomplished (effectively) by running:

        my $mycompiler = ExtUtils::F77->compiler();
        my $mycflags   = ExtUtils::F77->cflags();
        system( "$mycompiler -c -o $file.o $mycflags -O3 -fPIC $file.f" );

- Add Extra Linker Flags

        extra_linker_flags =>  $PDL::Config{MALLOCDBG}->{libs}
          if $PDL::Config{MALLOCDBG}->{libs};
        extra_linker_flags => ExtUtils::F77->runtime, <your fortran object files>

    Adds the linker flags from `ExtUtils::F77` and all the `.o` object files
    created from the `.f` Fortran files.

# SEE ALSO

[Module::Build::Pluggable](https://metacpan.org/pod/Module::Build::Pluggable), [Module::Build](https://metacpan.org/pod/Module::Build)

# AUTHOR

Mark Grimes, <mgrimes@cpan.org>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Mark Grimes, <mgrimes@cpan.org>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

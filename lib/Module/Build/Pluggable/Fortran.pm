package Module::Build::Pluggable::Fortran;

use strict;
use warnings;
use parent qw{Module::Build::Pluggable::Base};

BEGIN {
    eval "use ExtUtils::F77";
    if ($@) {
        warn "ExtUtils::F77 module not found. Build not possible.\n";
        exit 0;
    }
    if ( not ExtUtils::F77->runtimeok ) {
        warn "No Fortran compiler found. Build not possible.\n";
        exit 0;
    }
    if ( not ExtUtils::F77->testcompiler ) {
        warn "No fortran compiler found. Build not possible.\n";
        exit 0;
    }
}

sub HOOK_configure {
    my ($self) = @_;

    $self->builder_class->add_property('f_source');
    ## Can't validate here b/c of HOOK_configure calling order

    return 1;
}

sub HOOK_build {
    my ($self) = @_;

    my $mycompiler = ExtUtils::F77->compiler();
    my $mycflags   = ExtUtils::F77->cflags();
    undef $mycflags if $mycflags =~ m{^\s*}; # Avoid empty arg in cmd

    # We don't seem to be able to access the property created by add_property
    # in HOOK_configure (ditto if we move that to HOOK_build), we are going to
    # have to pry our way into builder and access f_source directly.
    # my $f_source = $self->builder->f_source;
    my $f_source = $self->builder->{properties}->{f_source};
    my @f_source_dirs = ref $f_source eq 'ARRAY' ? @$f_source : ($f_source);

    for my $f_src_dir (@f_source_dirs) {
        my $f_src_files = $self->builder->rscan_dir( $f_src_dir, qr/\.f$/ );

        for my $f_src_file (@$f_src_files) {
            ( my $file = $f_src_file ) =~ s{\.f$}{};

            my @cmd = (
                $mycompiler, '-c', '-o', "$file.o", ( $mycflags || () ),
                "-O3", "-fPIC", "$file.f"
            );

            print join( " ", @cmd ), "\n";
            $self->builder->do_system(@cmd)
              or die "error compiling $file";

            $self->builder->add_to_cleanup("$file.o");
        }
    }

    return 1;
}

1;

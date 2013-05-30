use Module::Build;
my $build = Module::Build->new(
    module_name   => 'Module::Build::Pluggable::Fortran',
    license       => 'perl',
    create_readme => 1,

    configure_requires => {
        'Module::Build' => '0.4005',
    },

    requires => {
        'Module::Build::Pluggable::Base' => 0,
        'ExtUtils::F77'                  => 0,
    },

    test_requires => {
        'Test::More'      => 0.87,
        'IPC::Cmd'        => 0,
        'Path::Class'     => 0,
        'List::MoreUtils' => 0,
    },

    meta_merge => {
        resources => {
            bugtracker =>
              'http://rt.cpan.org/NoAuth/Bugs.html?Dist=Module-Build-Pluggable-Fortran',
            repository => 'http://github.com/mvgrimes/mb-pluggable-fortran'
        }
    },
);

$build->create_build_script;

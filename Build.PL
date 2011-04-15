use strict;
use warnings;

use Module::Build;

eval { require ExtUtils::CChecker; 1 } or
   die "OS unsupported - missing ExtUtils::CChecker";

my $cc = ExtUtils::CChecker->new();

$cc->find_libs_for(
   libs => [ "resolv" ],
   source => <<'EOF' );
#include <netinet/in.h>
#include <arpa/nameser.h>
#include <resolv.h>
int main(int argc, char *argv[]) {
   void *q = &res_query;
   return 0;
}
EOF

my $build = $cc->new_module_build(
   module_name => 'Net::LibResolv',
   configure_requires => {
      'ExtUtils::CChecker' => 0,
   },
   requires => {
   },
   build_requires => {
      'ExtUtils::CChecker' => 0,
      'Module::Build' => 0,
      'Module::Build::Compat' => 0,
      'Test::More' => 0,
   },
   license => 'perl',
   create_makefile_pl => 'small',
   create_license => 1,
   create_readme  => 1,
);

$build->create_build_script;

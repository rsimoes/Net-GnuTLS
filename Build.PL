use strict;
use warnings;
use utf8;
use Module::Build;
use File::Spec;
use Data::Dump;

my $builder = Module::Build->new(
	dist_name => "Net-GnuTLS",
	license => "LGPL_3_0",
	dist_abstract => "Perl bindings to GnuTLS, a secure communications library",
	dist_author => q"Richard Simões <rsimoes AT cpan DOT org>",
	dist_version_from => "lib/Net/GnuTLS.pm",
	extra_linker_flags => ["-lgnutls"],
	c_source => "src",
	# Prerequisites inserted by DistZilla:
	##{ $plugin->get_prereqs ##}
   )->create_build_script;

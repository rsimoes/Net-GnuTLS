use v5.10;
use strict;
use warnings;
use Test::More tests => 2;
use Data::Dump;
use Net::GnuTLS;
use Class::Inspector;

my $session = Net::GnuTLS::init(GNUTLS_CLIENT);
isa_ok $session, "Net::GnuTLS::Session";
my $creds = Net::GnuTLS::certificate_allocate_credentials();
isa_ok $creds, "Net::GnuTLS::Credentials::Certificate";

my $pem_file;
SKIP: {
	eval { require Mozilla::CA };
	skip "Rest of tests require Mozilla::CA to be installed" if $@;
	$pem_file = Mozilla::CA::SSL_ca_file();
	Net::GnuTLS::certificate_set_x509_trust_file(
		$creds, $pem_file, GNUTLS_X509_FMT_PEM );
	Net::GnuTLS::priority_set_direct($session, "PERFORMANCE");
	Net::GnuTLS::credentials_set($session, GNUTLS_CRD_CERTIFICATE, $creds); }


__END__

my $session = GnuTLS::init(GNUTLS_CLIENT);
Net::GnuTLS::priority_set_direct($session, "PERFORMANCE");
Net::GnuTLS::credentials_set($session, GNUTLS_CRD_CERTIFICATE, $creds);
Net::GnuTLS::transport_set($session, $SKT);
Net::GnuTLS::handshake($session);
Net::GnuTLS::record_send($session, "GET / HTTP/1.0\r\n\r\n");
Net::GnuTLS::record_recv($session, my $buffer, 1024);
Net::GnuTLS::bye($session, GNUTLS_SHUT_RDWR);
shutdown($SKT, SHUT_RDWR);
Net::GnuTLS::deinit($session);
Net::GnuTLS::certificate_free_credentials($creds);

package Net::GnuTLS;

use v5.10;
use strict;
use warnings FATAL => "all";
use parent "DynaLoader";

# VERSION
# ABSTRACT: Perl bindings to GnuTLS, a secure communications library

__PACKAGE__->bootstrap;

END { global_deinit() }

1;

__END__

=pod

=encoding utf-8

=head1 NAME

Net::GnuTLS - Perl bindings to GnuTLS, a secure communications library

=head1 SYNOPSIS

=head2 Client

    use Socket qw(getaddrinfo SHUT_RDWR SOCK_STREAM);
    use Net::GnuTLS qw(GNUTLS_CLIENT GNUTLS_CRD_CERTIFICATE
                       GNUTLS_SHUT_RDWR GNUTLS_X509_FMT_PEM);

    my %hints = ( socktype => SOCK_STREAM );
    my ($err, $ainfo) = getaddrinfo( "metaperl.org", "echo", \%hints );
    socket( my $SKT, @{$ainfo}{qw(family type protocol)} ) || die "socket: $!";
    connect( $SKT, $ainfo->{addr} ) || die "connect: $!";

    my $creds = certificate_allocate_credentials();
    Net::GnuTLS::certificate_set_x509_trust_file("ca.pem", GNUTLS_X509_FMT_PEM);
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

=head2 Server

=head1 DESCRIPTION

=head1 FUNCTIONS

=over

=item C<alert_get($session)>

Returns the last alert number received. This function should be called if
GNUTLS_E_WARNING_ALERT_RECEIVED or GNUTLS_E_FATAL_ALERT_RECEIVED has been
returned by a gnutls function. The peer may send alerts if she thinks some
things were not right.

If no alert has been received the returned value is C<undef>.

=item C<alert_get_name($alert_num)>

Returns a string that describes the given alert number, or C<undef>. See
C<alert_get>.

=item C<alert_send_appropriate($session, $error_code)>

Sends an alert to the peer depending on the error code returned by a gnutls
function. Returns C<GNUTLS_E_SUCCESS>, C<GNUTLS_E_AGAIN>, or
C<GNUTLS_E_INTERRUPTED>. If an invalid request is made, the function croaks, and
no alert is sent to the peer.

=item C<alert_send($session, $level, $msg_text)>

Sends an alert to the peer in order to inform her of something important (e.g.,
her Certificate could not be verified). If the alert level is Fatal then the
peer is expected to close the connection, otherwise he may ignore the alert and
continue.

Returns C<GNUTLS_E_SUCCESS>, C<GNUTLS_E_INTERRUPTED>, or C<GNUTLS_E_AGAIN>.

=item C<anon_allocate_client_credentials($server_creds)>

Creates and returns a data structure representing anonymous client credentials.

=item C<anon_free_client_credentials($client_creds)>

Deletes the data structure created by C<anon_allocate_client_credentials()>.
Automatically called when the client credentials variable goes out of scope.

=item C<anon_allocate_server_credentials()>

Creates and returns a data structure representing anonymous server credentials.

=item C<anon_free_server_credentials($server_creds)>

Deletes the data structure created by C<anon_allocate_server_credentials()>.
Automatically called when the server credentials variable goes out of scope.

=item C<anon_set_params_function($server_creds, \&callback)>

Sets a callback in order for the server to get the Diffie-Hellman or RSA
parameters for anonymous authentication. The callback should return 0 (zero)
on success.

=item C<anon_set_server_dh_params($server_creds, $params>

=item C<anon_set_server_params_function($server_creds, \&callback)>

=item C<auth_client_get_type($session)>

Returns the type of credentials that were used for client authentication. The
returned information is to be used to distinguish the function used to access
authentication data.

=item C<auth_get_type($session)>

=item C<auth_server_get_type($session)>

=item C<bye($session[, $how])>

Terminates the current TLS/SSL connection. The connection should have been
initiated using C<handshake()>. C<$how> should be one of C<GNUTLS_SHUT_RDWR>
(default) and C<GNUTLS_SHUT_WR>.

In case of C<GNUTLS_SHUT_RDWR>, the TLS connection gets terminated and further
receives and sends will be disallowed. If the return value is zero you may
continue using the connection. C<GNUTLS_SHUT_RDWR> actually sends an alert
containing a close request and waits for the peer to reply with the same
message.

In case of C<GNUTLS_SHUT_WR>, the TLS connection gets terminated and further
sends will be disallowed. In order to reuse the connection you should wait for
an C<eof> from the peer. GNUTLS_SHUT_WR sends an alert containing a close
request.

Note that not all implementations will properly terminate a TLS connection. Some
of them, usually for performance reasons, will terminate only the underlying
transport layer, thus causing a transmission error to the peer. This error
cannot be distinguished from a malicious party prematurely terminating the
session, thus this behavior is not recommended.

Returns C<GNUTLS_E_SUCCESS>, C<GNUTLS_E_AGAIN>, or C<GNUTLS_E_INTERRUPTED>.

=back

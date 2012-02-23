package Net::GnuTLS::Client;

use strict;
use warnings FATAL => "all";
use utf8;
use Net::GnuTLS;

# VERSION
# ABSTRACT: High-level GnuTLS client library

1;

__END__

=encoding utf-8

=head1 NAME

Net::GnuTLS::Client - High-level GnuTLS client library

=head1 SYNOPSIS

    use IO::Socket::IP;
    use Socket qw(SOCK_STREAM SHUT_RDWR)
    use Net::GnuTLS::Client;
    use Net::GnuTLS::Credentials;

    # Connect to server:

    my $socket = IO::Socket::IP->new(
        PeerHost => "metacpan.org",
        PeerPort => "https",
        Type     => SOCK_STREAM ) or die "Cannot construct socket - $@";

    # Perform TLS handshake:

    my $client = Net::GnuTLS::Client->new;
    my $creds = Net::GnuTLS::Credentials->new( x509_file => "ca.pem" );
    $client->transport($socket);
    $client->credentials($creds);
    $client->handshake or die "Handshake error $!: $@";

    # Send and receive:

    $client->send("GET / HTTP/1.0\r\n\r\n");
    my $response = $client->recv(1024) or die "Error $!: $@";
    print $response->buffer, "\n";

    # Upon losing interest:

    $client->deinit;
    $socket->shutdown;

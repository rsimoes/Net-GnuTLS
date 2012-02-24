#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "ppport.h"
#include <gnutls/gnutls.h>

typedef gnutls_session_t                 Net__GnuTLS__Session;
typedef gnutls_certificate_credentials_t Net__GnuTLS__Credentials__Certificate;

MODULE = Net::GnuTLS    PACKAGE = Net::GnuTLS    PREFIX = gnutls_

BOOT:
int success = gnutls_global_init();
if ( gnutls_global_init() != 0 ) croak("Failed to initialize GnuTLS");

Net::GnuTLS::Credentials::Certificate
gnutls_certificate_allocate_credentials()
	PROTOTYPE:
	PREINIT:
		int error;
		Net__GnuTLS__Credentials__Certificate creds;
	CODE:
		error = gnutls_certificate_allocate_credentials(&creds);
		if (error) croak("session initialization error");
		RETVAL = creds;
	OUTPUT:
		RETVAL

Net::GnuTLS::Session
gnutls_init(con_end)
		gnutls_connection_end_t con_end;
	PROTOTYPE: $
	PREINIT:
		int error;
		Net__GnuTLS__Session session;
	CODE:
		error = gnutls_init( &session, con_end );
		if (error) croak("session initialization error");
		RETVAL = session;
	OUTPUT:
		RETVAL

int
gnutls_global_init()
	 PROTOTYPE:

void
gnutls_global_deinit()
	 PROTOTYPE:


MODULE = Net::GnuTLS  PACKAGE = Net::GnuTLS::Session

void
DESTROY(session)
	Net::GnuTLS::Session session
	CODE:
		printf("Now in Net::GnuTLS::Session::DESTROY\n");
		gnutls_deinit(session);


MODULE = Net::GnuTLS  PACKAGE = Net::GnuTLS::Credentials::Certificate

void
DESTROY(creds)
		Net::GnuTLS::Credentials::Certificate creds
	CODE:
		gnutls_certificate_free_credentials(creds);

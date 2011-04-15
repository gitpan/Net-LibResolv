/*  You may distribute under the terms of either the GNU General Public License
 *  or the Artistic License (the same terms as Perl itself)
 *
 *  (C) Paul Evans, 2011 -- leonerd@leonerd.org.uk
 */

#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include <netinet/in.h>
#include <arpa/nameser.h>
#include <resolv.h>

MODULE = Net::LibResolv      PACKAGE = Net::LibResolv

SV *
res_query(dname, class, type)
  char *dname
  int   class
  int   type
  PREINIT:
    unsigned char answer[512];
    int len;
  CODE:
    len = res_query(dname, class, type, answer, sizeof answer);
    if(len == -1)
      XSRETURN_UNDEF;
    RETVAL = newSVpvn(answer, len);
  OUTPUT:
    RETVAL

SV *
res_search(dname, class, type)
  char *dname
  int   class
  int   type
  PREINIT:
    unsigned char answer[512];
    int len;
  CODE:
    len = res_search(dname, class, type, answer, sizeof answer);
    if(len == -1)
      XSRETURN_UNDEF;
    RETVAL = newSVpvn(answer, len);
  OUTPUT:
    RETVAL

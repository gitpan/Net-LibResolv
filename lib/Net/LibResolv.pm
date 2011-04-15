#  You may distribute under the terms of either the GNU General Public License
#  or the Artistic License (the same terms as Perl itself)
#
#  (C) Paul Evans, 2011 -- leonerd@leonerd.org.uk

package Net::LibResolv;

use strict;
use warnings;

our $VERSION = '0.01';

use Exporter 'import';
our @EXPORT_OK = qw(
   res_query
   res_search
);
our %EXPORT_TAGS;

require XSLoader;
XSLoader::load( __PACKAGE__, $VERSION );

=head1 NAME

C<Net::LibResolv> - a Perl wrapper around F<libresolv>

=head1 SYNOPSIS

 use Net::LibResolv qw( res_query NS_C_IN NS_T_A );
 use Net::DNS::Packet;
 
 my $answer = res_query( "www.cpan.org", NS_C_IN, NS_T_A );
 defined $answer or die "DNS failure\n";
 
 foreach my $rr ( Net::DNS::Packet->new( \$answer )->answer ) {
    print $rr->string, "\n";
 }

=head1 DESCRIPTION

The F<libresolv> library provides functions to use the platform's standard DNS
resolver to perform DNS queries. This Perl module provides a wrapping for the
two primary functions, C<res_query(3)> and C<res_search(3)>, allowing them to
be used from Perl.

The return value from each function is a byte buffer containing the actual DNS
response packet. This will need to be parsed somehow to obtain the useful
information out of it; most likely by using L<Net::DNS>.

=cut

=head1 FUNCTIONS

=cut

# These functions are implemented in XS

=head2 $answer = res_query( $dname, $class, $type )

Calls the C<res_query(3)> function on the given domain name, class and type
number. Returns the answer byte buffer on success, or C<undef> on failure.

C<$dname> should be a plain string. C<$class> and C<$type> should be numerical
codes. See the C<CONSTANTS> section for convenient definitions.

=cut

=head2 $answer = res_search( $dname, $class, $type )

Calls the C<res_search(3)> function on the given domain name, class and type
number. Returns the answer byte buffer on success, or C<undef> on failure.

C<$dname> should be a plain string. C<$class> and C<$type> should be numerical
codes. See the C<CONSTANTS> section for convenient definitions.

=cut

=head1 CONSTANTS

=cut

sub _setup_constants
{
   my %args = @_;

   my $prefix = $args{prefix};
   my $values = $args{values};
   my $tag    = $args{tag};

   require constant;
   constant->import( "$prefix$_" => $values->{$_} ) for keys %$values;

   push @EXPORT_OK, map "$prefix$_", keys %$values;

   $EXPORT_TAGS{$tag} = [ map "$prefix$_", keys %$values ];
}

# These constants are defined by RFCs, primarily RFC 1035 and friends. We
# shouldn't need to pull these out of platform .h files as they're portable
# constants

=head2 Class IDs

The following set of constants define values for the C<$class> parameter.
Typically only C<NS_C_IN> is actually used, for Internet.

 NS_C_IN NS_C_CHAOS NS_C_HS
 NS_C_INVALD NS_C_NONE NS_C_ANY

=cut

_setup_constants
   prefix => "NS_C_",
   tag    => ":classes",
   values => {
      INVALID => 0,
      IN      => 1,
      CHAOS   => 3,
      HS      => 4,
      NONE    => 254,
      ANY     => 255,
   };

=head2 Type IDs

The following are examples of constants define values for the C<$type>
parameter. (They all follow the same naming pattern, named after the record
type, so only a few are listed here.)

 NS_T_A NS_T_NS NS_T_CNAME NS_T_PTR NS_T_MX NS_T_TXT NS_T_SRV NS_T_AAAA
 NS_T_INVALID NS_T_ANY

=cut

# The following list shamelessly stolen from <arpa/nameser.h>
_setup_constants
   prefix => "NS_T_",
   tag    => ":types",
   values => {
      INVALID  => 0,
      A        => 1,
      NS       => 2,
      MD       => 3,
      MF       => 4,
      CNAME    => 5,
      SOA      => 6,
      MB       => 7,
      MG       => 8,
      MR       => 9,
      NULL     => 10,
      WKS      => 11,
      PTR      => 12,
      HINFO    => 13,
      MINFO    => 14,
      MX       => 15,
      TXT      => 16,
      RP       => 17,
      AFSDB    => 18,
      X25      => 19,
      ISDN     => 20,
      RT       => 21,
      NSAP     => 22,
      NSAP_PTR => 23,
      SIG      => 24,
      KEY      => 25,
      PX       => 26,
      GPOS     => 27,
      AAAA     => 28,
      LOC      => 29,
      NXT      => 30,
      EID      => 31,
      NIMLOC   => 32,
      SRV      => 33,
      ATMA     => 34,
      NAPTR    => 35,
      KX       => 36,
      CERT     => 37,
      A6       => 38,
      DNAME    => 39,
      SINK     => 40,
      OPT      => 41,
      APL      => 42,
      TKEY     => 249,
      TSIG     => 250,
      IXFR     => 251,
      AXFR     => 252,
      MAILB    => 253,
      MAILA    => 254,
      ANY      => 255,
   };

=head1 AUTHOR

Paul Evans <leonerd@leonerd.org.uk>

=cut

0x55AA;

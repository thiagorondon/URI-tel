
package URI::tel;

use Moose;
use Moose::Util::TypeConstraints;

our $VERSION = '0.01';

=head1 NAME

URI::tel - The tel URI for Telephone Numbers (RFC 3966)

=head1 SYNOPSIS

    use URI::tel;

    my $uri_client = new URI::tel;

    $uri_client->telephone_uri('tel:+1-201-555-0123');
    print $uri_client->telephone_subscriber, "\n";

    $uri_client->telephone_uri('tel:7042;phone-context=example.com');
    print $uri_client->context, "\n";

=head1 DESCRIPTION

The termination point of the "tel" URI telephone number is not
restricted.  It can be in the public telephone network, a private
telephone network, or the Internet.  It can be fixed or wireless and
address a fixed wired, mobile, or nomadic terminal.  The terminal
addressed can support any electronic communication service (ECS),
including voice, data, and fax.  The URI can refer to resources
identified by a telephone number, including but not limited to
originators or targets of a telephone call.

The "tel" URI is a globally unique identifier ("name") only; it does
not describe the steps necessary to reach a particular number and
does not imply dialling semantics.  Furthermore, it does not refer to
a specific physical device, only to a telephone number.

Changes Since RFC 2806

The specification is syntactically backwards-compatible with the
"tel" URI defined in RFC 2806 [RFC2806] but has been completely
rewritten.  This document more clearly distinguishes telephone
numbers as identifiers of network termination points from dial
strings and removes the latter from the purview of "tel" URIs.

Compared to RFC 2806, references to carrier selection, dial context,
fax and modem URIs, post-dial strings, and pause characters have been
removed.  The URI syntax now conforms to RFC 2396 [RFC2396].

=cut

our %syntax = ( 
    'telephone_subscriber'  => '^tel:',
    'isdn_subaddress'       => '.*;isub=',
    'extension'             => '.*;ext=',
    'context'               => '.*;phone-context='
);

subtype 'Istel'
    => as 'Str'
    => where { $_ =~ /^tel:/ }
    => message { 'tel must init with tel:' };

has 'telephone_uri' => (
    is => 'rw',
    isa => 'Istel',
    trigger => sub {
        my $self = shift;
        $self->$_() for map {'_clear_' . $_ } keys %syntax;
    }
);

for my $field (keys %syntax) {
    has $field => (
        is => 'ro',
        isa => 'Str',
        lazy => 1,
        clearer => ('_clear_' . $field),
        default => sub {
            my $self = shift;
            my $str = $self->telephone_uri;
            $str =~ s/$syntax{"$field"}//g;
            $str;
        }
    ); 
}

1;

__END__

=head1 AUTHOR

Thiago Rondon <thiago@aware.com.br>

http://www.aware.com.br/

=head1 LICENSE

Perl License.

=cut


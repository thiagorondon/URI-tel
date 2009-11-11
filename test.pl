
BEGIN {
    push @INC, './lib/';
}

use URI::tel;

my $uri_client = new URI::tel;

$uri_client->telephone_uri('tel:+1-201-555-0123');
print $uri_client->telephone_subscriber, "\n";

$uri_client->telephone_uri('tel:7042;phone-context=example.com');
print $uri_client->context, "\n";

print $uri_client->tel_cmp('tel:123', 'tel:1(2)3'), "\n";



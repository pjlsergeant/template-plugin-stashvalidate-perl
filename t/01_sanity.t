#!perl

use strict;
use warnings;
use Test::Exception;
use Test::More;
use Template;

# Here is a template that insists the stash contains 'foo' as an arrayref, and
# 'bar' as an int.
my $source = <<TT;
[% USE StashValidate {
    'foo' => { isa => 'ArrayRef' },
    'bar' => { isa => 'Int' },
} %]
TT

# Here is a stash that meets those requirements
my $good_data = { foo => [], bar => 5 };
# And here is a stash that does not meet those requirements
my $bad_data =  { foo => {}, bar => 5 };

# Here is a coderef that attempts to render the template with a passed-in stash
my $render = sub {
    my $data = shift;
    my $output = ''; # Temporary string that we can use to hold output
    my $template = Template->new();
    $template->process( \$source, $data, \$output ) || die $template->error();
};

# Test that with the good data it works
lives_ok( sub { $render->( $good_data ) }, "Lives when given correct params");

# Test that with the bad data it throws an error
throws_ok( sub { $render->( $bad_data )}, qr/ArrayRef/,
    "Dies when given bad params");

done_testing();

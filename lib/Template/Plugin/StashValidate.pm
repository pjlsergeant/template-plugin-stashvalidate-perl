package Template::Plugin::StashValidate;

=head1 NAME

Template::Plugin::StashValidate - MooseX::Params::Validate for template stash values

=head1 DESCRIPTION

Allows a template to validate specific hash keys via MooseX::Params::Validate

=head1 SYNOPSIS

 [% USE StashValidate {
    'advice_discrepant' => { 'isa' => 'ArrayRef | HashRef', 'optional' => 1 }
  } %]

=head1 OVERVIEW

Allows a template to validate keys from the stash (L<Template::Stash>) using
L<MooseX::Params::Validate>. Accepts a hashref as the sole argument, and this is
the C<parameter_spec> that's passed straight through to
L<MooseX::Params::Validate>'s C<validated_hash>. We only validate elements in
the stash for which you've specified an allowed value - other keys in the stash
are ignored.

B<In short, for options, see>: L<MooseX::Params::Validate>.

=cut

use strict;
use warnings;
use MooseX::Params::Validate;
use base 'Template::Plugin';

=head1 METHODS

=head2 new

This is the method called when you say C<[% USE StashValidate {} %]>, as per
the documentation in L<Template::Plugin>.

=cut

sub new {
    my ($class, $context, $params) = @_;
    my %check = map {
        $_ => ($context->stash->get( $_ ) || undef)
    } keys %$params;

    eval { validated_hash( [%check], %$params ) };
    if ( $@ ) {
        # If you're thinking "this is really weird", then yes, you're right.
        # Scumbag Template::Toolkit.
        $class->error( $@ );
        die $class->error();
    }
    1;
}

=head1 AUTHOR

Peter Sergeant - C<pete@clueball.com>, while working for
L<Net-A-Porter|http://www.net-a-porter.com/>.

=cut

1;

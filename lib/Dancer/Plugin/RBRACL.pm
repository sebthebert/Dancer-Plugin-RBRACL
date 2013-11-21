
=head1 NAME

Dancer::Plugin::RBRACL

=head1 DESCRIPTION

Role Based Routes Access Control List

=cut

package Dancer::Plugin::RBRACL;

use warnings;
use strict;

use Dancer qw(:syntax);
use Dancer::Plugin;

use  Data::Dumper;
 
our $VERSION = '0.2';

=head1 SUBROUTINES/METHODS

=head2 _Routes()

Returns list of Routes

=cut

sub _Routes
{
    my @routes = ();
    
    foreach my $app (Dancer::App->applications)
    {
        my $reg_routes = $app->{registry}->{routes};
        foreach my $method (keys %{$reg_routes})
        {
            foreach my $r (@{$reg_routes->{$method}})
            {
                push @routes, { method => $r->{method}, pattern => $r->{pattern} };
            }
        }
    }
    
    return (@routes);
}

=head2 Save_Role

=cut

sub Save_Role
{
    
}

#set prefix => '/user'

get '/rbracl/user/:username?' => sub
{
    my $username = params->{'username'};
};

get '/rbracl/usergroup/:usergroupname?' => sub
{
    my $usergroupname = params->{'usergroupname'};
};

=head2 get '/rbracl/role/:?rolename'

Dancer Route to get configuration for Role 'rolename'

=cut

get '/rbracl/role/:rolename?' => sub
{
    my $rolename = params->{'rolename'};
    my @routes = sort { $a->{pattern} cmp $b->{pattern} }_Routes();
    
    template 'rbracl/role', { rolename => $rolename, routes => \@routes };
};

=head2 post '/rbracl/role/:rolename'

Dancer Route to save Role configuration

=cut

post '/rbracl/role' => sub
{
    
};


1;

=head1 AUTHOR

Sebastien Thebert <stt@ittool.org>

=cut


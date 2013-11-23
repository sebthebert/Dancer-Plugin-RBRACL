
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
use File::Slurp;
use FindBin;
use JSON;

our $VERSION = '0.2';

my $FILE_ROLES = "$FindBin::Bin/../conf/RBRACL_roles.json";
my $FILE_USERS = "$FindBin::Bin/../conf/RBRACL_users.json";
my $FILE_USERGROUPS = "$FindBin::Bin/../conf/RBRACL_usergroups.json";

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

=head2 Load_Roles()

Load Roles from RBRACL Roles file

=cut

sub Load_Roles
{
    if (-f $FILE_ROLES)
    {
        my $content = read_file($FILE_ROLES); 
        my $conf_roles = from_json($content, { utf8 => 1 });
        
        return ($conf_roles);
    }
    
    return (undef);
}

=head2 Load_Users()

Load Users from RBRACL Users file

=cut

sub Load_Users
{
    if (-f $FILE_USERS)
    {
        my $content = read_file($FILE_USERS); 
        my $conf_users = from_json($content, { utf8 => 1 });
        
        return ($conf_users);
    }
    
    return (undef);
}

=head2 Load_UserGroups()

Load UserGroups from RBRACL UserGroups file

=cut

sub Load_UserGroups
{
    if (-f $FILE_USERGROUPS)
    {
        my $content = read_file($FILE_USERGROUPS); 
        my $conf_usergroups = from_json($content, { utf8 => 1 });
        
        return ($conf_usergroups);
    }
    
    return (undef);
}

=head2 Save_Role($name, $desc, $patterns)

Saves Role to RBRACL Roles file

=cut

sub Save_Role
{
    my ($name, $desc, $patterns) = @_;
    
    my $conf_roles = Load_Roles(); 
    $conf_roles->{$name} = { description => $desc, patterns => $patterns };
    
    my $json = to_json($conf_roles, { pretty => 1, utf8 => 1 });
    write_file($FILE_ROLES, $json);
}

=head1 ROUTES

=head2 get '/rbracl/user/:username?'

=cut

get '/rbracl/user/:username' => sub
{
    my $username = params->{'username'};
    my $conf_roles = Load_Roles();
    
    template 'rbracl/user', 
        { username => $username, roles => $conf_roles };
};

=head2 get '/rbracl/users'

Dancer Route to list Users

=cut

get '/rbracl/users' => sub
{
    my $conf_users = Load_Users();
    
    template 'rbracl/users', { users => $conf_users };
};

=head2 get '/rbracl/usergroup/:usergroupname'

=cut

get '/rbracl/usergroup/:usergroupname' => sub
{
    my $usergroupname = params->{'usergroupname'};
    
    my $conf_roles = Load_Roles();
    
    template 'rbracl/usergroup', 
        { usergroupname => $usergroupname, roles => $conf_roles };
};

=head2 get '/rbracl/usergroups'

Dancer Route to list UserGroups

=cut

get '/rbracl/usergroups' => sub
{
    my $conf_usergroups = Load_UserGroups();
    
    template 'rbracl/usergroups', { usergroups => $conf_usergroups };
};

=head2 get '/rbracl/role/:rolename'

Dancer Route to get configuration for Role 'rolename'

=cut

get '/rbracl/role/:rolename' => sub
{
    my $rolename = params->{'rolename'};
    my @routes = sort { $a->{pattern} cmp $b->{pattern} }_Routes();
    
    template 'rbracl/role', { rolename => $rolename, routes => \@routes };
};

=head2 post '/rbracl/role'

Dancer Route to save Role configuration

=cut

post '/rbracl/role' => sub
{
    my $p = request->params;   
    
    Save_Role($p->{name}, $p->{description}, $p->{patterns});
    
    redirect '/rbracl/roles';
};

=head2 get '/rbracl/roles'

Dancer Route to list Roles

=cut

get '/rbracl/roles' => sub
{
    my $conf_roles = Load_Roles();
    
    template 'rbracl/roles', { roles => $conf_roles };
};

1;

=head1 AUTHOR

Sebastien Thebert <stt@ittool.org>

=cut


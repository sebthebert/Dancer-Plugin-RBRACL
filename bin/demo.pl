#!/usr/bin/perl

use strict;
use warnings;

use Dancer;
use FindBin;

set logger => 'console';
set session => 'YAML';

use lib "$FindBin::Bin/../lib";

use Dancer::Plugin::RBRACL;

hook 'before' => sub 
{
    
};

dance;

=head1 AUTHOR

Sebastien Thebert <support@octopussy.pm>

=cut
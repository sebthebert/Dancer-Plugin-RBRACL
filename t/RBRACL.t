#!/usr/bin/perl

use strict;
use warnings;

use FindBin;

use lib "$FindBin::Bin/.";
use TestDancerApp;

use lib "$FindBin::Bin/../lib";
use Dancer::Plugin::RBRACL;

my @routes = Dancer::Plugin::RBRACL::_Routes();
foreach my $r (@routes)
{
    printf "%s %s\n", $r->{method}, $r->{pattern};
}
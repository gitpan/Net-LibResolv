#!/usr/bin/perl -w

use strict;

use Test::More tests => 3;

use Net::LibResolv qw( res_query NS_C_IN NS_T_A NS_T_MX );

is( NS_C_IN,  1, 'NS_C_IN' );
is( NS_T_A,   1, 'NS_T_A' );
is( NS_T_MX, 15, 'NS_T_MX' );

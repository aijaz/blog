#!/usr/bin/perl

use strict;
use warnings;

my @categories = ();
my @tags = ();

my $inCat = 0;
my $inTag = 0;
while ($_ = <>) {
	if (/^$/) { last; }
	if (/^title/i) {
		s/\"//g;
	}
	if (/^description/i) {
		s/\"//g;
	}
	print;
}

print "\n";
while ($_ = <>) {
	print;
}
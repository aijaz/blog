#!/usr/bin/perl

use strict;
use warnings;

my @categories = ();
my @tags = ();

my $inCat = 0;
my $inTag = 0;
while ($_ = <>) {
	if (/^---/) { next }
	if (/^$/) { last; }
	if (/^category/i) {
		$inCat = 1; 
		$inTag = 0;
		next;
	}
	if (/^tags/i) {
		$inCat = 0; 
		$inTag = 1;
		next;
	}
	if ($inCat && / *\- */) {
		chomp;
		s/^ *\- *//;
		push (@categories, $_);
	}
	elsif ($inTag && / *\- */) {
		chomp;
		s/^ *\- *//;
		push (@tags, $_);
	}
	else {
		$inCat = 0;
		$inTag = 0;
		print;
	}
}
if (@categories) { print "Category: "; print join(', ', @categories); print "\n"; }
if (@tags) { print "Tags: "; print join(', ', @tags); print "\n"; }

print "\n";
while ($_ = <>) {
	print;
}
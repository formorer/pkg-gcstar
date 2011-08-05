#!/usr/bin/perl

use XML::LibXSLT;

my $xslfile = $ARGV[0];
my $xmlfile = $ARGV[1];

my $xslt = XML::XSLT->new($xslfile, warnings => 1);

$xslt->transform($xmlfile);
print $xslt->toString;

$xslt->dispose;

#!/usr/local/bin/perl -w
# $Id: cgi_usage.t,v 1.4 2005/02/07 09:52:46 piersk Exp $

use strict;
use Log::Trace;
use Test::Assertions 'test';
use FindBin;
use Getopt::Std;

use vars qw($opt_b $opt_t $opt_T);
getopts('btT');

if ($opt_t) { import Log::Trace 'print'; }
if ($opt_T) { import Log::Trace 'print' => { Deep => 1}; }

plan tests;

unshift @INC, "../lib";
require Pod::Usage::CGI;
ASSERT(1, "require Pod::Usage::CGI - v$Pod::Usage::CGI::VERSION");

import Pod::Usage::CGI;
ASSERT(defined &{"pod2usage"}, '... imports pod2usage()');

my $output = qx[$^X $FindBin::Dir/test_pod_usage.cgi];
# strip meta tags (contains filepaths, timestamps etc)
$output =~ s/<meta [^>]+\/>//g;
# strip carriage returns (which occur in the header)
$output =~ s/\r//g;

#Re-baseline if required
if($opt_b) {
	warn("baselining output file\n");
	WRITE_FILE($FindBin::Dir.'/test_pod_usage.out', $output);
}

TRACE($output);
ASSERT(EQUALS_FILE($output, $FindBin::Dir.'/test_pod_usage.out'), '... produces Xhtml output');


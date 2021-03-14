#!/usr/bin/env perl

use strict;
use warnings;
use utf8;

my $cmd = $ARGV[0];
my $str = $ARGV[1];

my $pid = fork;
die "Cannot fork: $!" unless defined $pid;

if ($pid == 0) {
    exec "$cmd $str";
    die "Can't exec date: $!";
}
waitpid($pid, 0);
print "$pid exited with status $?\n";

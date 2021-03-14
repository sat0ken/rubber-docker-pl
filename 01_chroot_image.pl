#!/usr/bin/env perl

use strict;
use warnings;
use utf8;
use File::Spec;
use Archive::Tar;

my $cmd = join(' ', @ARGV);

sub create_container_root {

    my $image_tar_file = "images/alpine.tar";
    my $container_dir  = "containers";
    my $container_id   = `uuidgen -r`;
    chomp($container_id);

    my $tar = Archive::Tar->new($image_tar_file);

    my $container_root = File::Spec->catfile($container_dir, $container_id, "rootfs");
    if (! -d $container_root) {
        mkdir $container_root, 0755;
    }

    $tar->setcwd($container_root);
    $tar->extract or die;

    return $container_root;

}

my $pid = fork;
die "Cannot fork: $!" unless defined $pid;

if ($pid == 0) {
    my $new_root = create_container_root();
    print "Created a new root fs for our container: $new_root\n";

    chroot $new_root;
    exec "$cmd";
    die "Can't exec date: $!";
}
waitpid($pid, 0);
print "$pid exited with status $?\n";

#!/usr/bin/perl -w

use PerlLib::SwissArmyKnife;


my $c = read_file('/var/lib/myfrdcsa/codebases/minor/cyc-mode/hybrid/subl-mode/process/temp.txt');
my @list;
my $i = 0;
foreach my $line (split /\n/, $c) {
  next if $line =~ /^[^a-zA-Z0-9_-]/;
  next if $line =~ /[^a-zA-Z0-9_-]/;
  next if $line =~ /^[-_]/;
  next if $line =~ /[-_]$/;
  ++$i;
  # last if $i > 100;
  $line =~ s/(\(|\)|\s).+//;
  $line =~ s/([^a-zA-Z0-9_-])/\\$1/sg;
  push @list,lc($line);
}

print '\\('.join('\\|',@list).'\\)\\b'."\n";

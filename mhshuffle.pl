#!/usr/bin/perl
use strict;

my @pairs = ("A", "A", "B", "B", "C", "C", "D", "D", "E", "E", "F", "F", "G", "G", "H", "H", "I", "I");
my @board = ();

sub find {
	my $needle = $_[0];
	my @haystack = @{$_[1]};
	my $i = scalar @haystack - 1;
	while ( $i > 0 && $needle ne $haystack[$i] ) {
		$i--;
	}
	return $i;
}

sub isSolved {
	my @board = @{$_[0]};
	my $boardsz = $_[1];
	if ( scalar @board < $boardsz ) { return 0; }
	my $i = 0;
# iterate through the board to check matches
	while ( $i < scalar @board && $board[$i] eq "X" ) {
		$i++;
	}
	return ( $i == scalar @board );
}

sub makePairs {
	my @board = @{$_[0]};
	if ( scalar @board < 2 ) { return @board; }
	for ( my $i = 0; $i < scalar @board; $i++ ) {
		my $j = $i + 1;
		while ( $j < scalar @board && $board[$i] ne "X" && $board[$i] ne $board[$j] ) {
			$j++;
		}
	# if found matching, mark as matched
		if ( $board[$i] ne "X" && $board[$i] eq $board[$j] ) {
			$board[$i] = "X";
			$board[$j] = "X";
		}
	}
	return @board;
}

sub solver {
	my @board = @{$_[0]};
# keep track of revealed cards
	my @known = ();
	my $tickets = 0;	# to keep track of tickets used
	my $i = 0;			# to keep track of cursor
	while ( scalar @known < scalar @board && ! isSolved(\@known, scalar @board) ) {
	# make any known pairs
		@known = makePairs(\@known);
	# reveal first card		
		if ( scalar @known > 1 && find($board[$i], \@known) ) {	# if first card has known partner
			push @known, $board[$i];
			@known = makePairs(\@known);
			$i++;
		} else {
			push @known, $board[$i];
			$i++;
			if ( $i < scalar @board ) { # check if last card of board
			# reveal second card
				push @known, $board[$i];
				if ( $board[$i-1] eq $board[$i] ) {	# if pair is formed	
					@known = makePairs(\@known);
				} else {					# no pair is made on this turn
					$tickets++;
				}
				$i++;
			}
		}
	}
	return $tickets;
}

sub shuffle {
	my @board = @{$_[0]};
	for ( my $i = 0; $i < scalar @board; $i++ ){
		my $temp = $board[$i];
		my $r = int(rand(scalar @board)) - 1;
		$board[$i] = $board[$r];
		$board[$r] = $temp;
	}
	return @board;
}

	my $runs = 10;	# run 10 times by default
	if ( scalar $ARGV[0] > 0 ) { $runs = scalar $ARGV[0]; }

	my @distribution = (0, 0, 0, 0, 0, 0, 0, 0, 0);
	printf "%-36.36s Tickets\n", "Board Layout";
# control solution
	@board = @pairs;
	printf "%s: %d\n", join(" ", @board), solver(\@board);
# random boards
	for ( my $i = 0; $i < $runs; $i++ ) {
		@board = shuffle(\@pairs);
		my $tries = solver(\@board);
		printf "%s: %d\n", join(" ", @board), $tries;
		$distribution[$tries]++;
	}
	print "\n\nDistributions\n";
	printf "Tickets   Occurrences\n";
	for ( my $i = 0; $i < scalar @distribution; $i++ ) {
		printf "%-7.7s:  %d\n", $i, $distribution[$i];
	}
	printf "Total  :  $runs\n";
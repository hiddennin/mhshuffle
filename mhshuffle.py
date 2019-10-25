#!/usr/bin/env python

import sys
from random import randint

pairs = ['A', 'A', 'B', 'B', 'C', 'C', 'D', 'D', 'E', 'E', 'F', 'F', 'G', 'G', 'H', 'H', 'I', 'I']
board = []

def find(needle, haystack):
	i = len(haystack) - 1
	while i > 0 and needle != haystack[i]:
		i -= 1
	return i

def isSolved(board, boardSize):
	if len(board) < boardSize:
		return 0
	i = 0
# iterate through the board to check matches
	while i < len(board) and board[i] != "X":
		i += 1
	return i == len(board)

def makePairs(board):
	if len(board) < 2:
		return board
	i = 0
	while i < len(board):
		j = i + 1
		while j < len(board) and board[i] != "X" and board[i] != board[j]:
			j += 1
	# if found matching, mark as matched
		if j < len(board) and board[i] != "X" and board[i] == board[j]:
			board[i] = "X"
			board[j] = "X"
		i += 1
	return board

def solver(board):
# keep track of revealed cards
	known = []
	tickets = 0		# to keep track of tickets used
	i = 0			# to keep track of cursor
	while len(known) < len(board) and not isSolved(known, len(board)):
	# make any known pairs
		known = makePairs(known)
	# reveal first card		
		if len(known) > 1 and find(board[i], known):	# if first card has known partner
			known.append(board[i])
			known = makePairs(known)
			i += 1
		else:
			known.append(board[i])
			i += 1
			if i < len(board):	# check if last card of board
			# reveal second card
				known.append(board[i])
				if board[i-1] == board[i]:				# if pair is formed
					known = makePairs(known)
				else:									# no pair is made on this turn
					tickets+= 1
				i += 1
	return tickets

def shuffle(board):
	i = 0
	while i < len(board):
		temp = board[i]
		r = randint(0, len(board)-1)
		board[i] = board[r]
		board[r] = temp
		i += 1
	return board


runs = 10	# run 10 times by default
if len(sys.argv) > 1 and int(sys.argv[1]) > 0:
	runs = int(sys.argv[1])
distributions = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
print "Board Layout                         Tickets"
# control solution
board = pairs
tries = solver(board)
print str(" ".join(board)) + ": " + str(tries)
# random boards
for i in range(runs):
	board = shuffle(pairs)
	tries = solver(board)
	print str(" ".join(board)) + ": " + str(tries)
	distributions[tries] += 1
print "\n\nDistributions"
print "Tickets   Occurrences"
for i in range(len(distributions)):
	print "%-7.7s:  %d" % (i, distributions[i])
print "Total  :  " + str(runs)


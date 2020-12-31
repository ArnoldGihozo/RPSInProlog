/*
Author: Arnold Gihozo
Date Created: November 27, 2020
Date Last Modified: December 10, 2020

Description:
The program bellow executes a simple Rock Paper Scissor Game
between computer and the user. This program was created within the scope
of the AUCSC 370 class class at the University of Alberta-Augustana Campus.
Its main goal is to get use with the Prolog programing language. The RPS Game
last for 10 rounds and is played between a computer and a user. The game is
played over terminal where the user has to input either "rock, paper or scissor"
any format and length. The program will accept the input as long as the first l
etter of the input matches one of the 3 options, othewise, the user will be
asked to try again. At the end of the 10 rounds, the game will display the
final score, the number of tied rounds, the final champion.
*/

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                             FACTS
%  This part will contain all my valid facts such as the initial score,
% the valid inputs (RrPpSs).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
:- dynamic myScore/3.
myScore(0,0,0).

% possible cases for the input
checkInput( 82, "ROCK").
checkInput( 114, "ROCK").
checkInput( 80, "PAPER").
checkInput( 112, "PAPER").
checkInput( 83, "SCISSOR").
checkInput( 115, "SCISSOR").

% converting the random generated number to a computer move
intToString(0, "ROCK").
intToString(1, "PAPER").
intToString(2, "SCISSOR").

% possible combination for computer to win
isWinner("ROCK", "SCISSOR").
isWinner("SCISSOR", "PAPER").
isWinner("PAPER", "ROCK").



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%        PART A- Getting User Input, Check the Input, Start Game Loop
% Program Execution starts here
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% This function is called in order to start the Rock Paper scissor game. It
% call the function gameFinish Loop which is initiate to 0 and goes on until
% the game is done (reaches 10 rounds).
%
% You will also see that the score is reset to 000 (userScore, ComputerScore,Ties),
% in case if user wants to play another round, the scores must be reset.

play:-
  retract(myScore(_,_,_)),
  assert(myScore(0,0,0)),
  write( 'Welcome to ROCK PAPER SCISSORS game'),
  nl,
  write( '--------------------------------------------------------------'),
  nl,
  gameFinishLoop(0).

% ------------------------------------------------------------------------------
% gameFinish(Rounds):- takes the input of rounds and keeps going till reaching10
% Game Finish loop is depended on an order. Meaning that I recursively
% call myself over here until the game is done call(endGame in that case)
% otherwise, I keep calling getUserInput. In theory tho,
gameFinishLoop(Rounds):-
  Rounds < 10,
  getUserInput,
  NewRound is Rounds + 1,
  gameFinishLoop(NewRound).

% If the case above returns false, means that we are end of our game, therefore
% having this as our base case
gameFinishLoop(Rounds):-
  Rounds == 10,
  endGame.

% ------------------------------------------------------------------------------
% getUserInput:- does take any input, and returns true if the input was correct
getUserInput:-
  write( 'Please enter your choice: \"Rock\", \"Paper\", or \"Scissors\"   '),
  getInput(Input),
  checkAndConvertValidInput(Input).

% gets the first element of the input and recursively calls intself until it
% reaches the "enter".
getInput([Head |Rest]):-
  get_code(Head),
  Head \= 10,
  getInput(Rest).

% base case
getInput([]).
% ------------------------------------------------------------------------------
% checks if input is correct by looking at the head of the list (thefore, first
% element)
% checkInput is a list of facts that the first element can be
checkAndConvertValidInput([Head |_]):-
  checkInput(Head,UserMove),
  getComputerInput(UserMove).

% if checkinput returns false, the function calls itself again to reask another
% input
checkAndConvertValidInput(_):-
  write('Not Valid Input'),
  nl,
  getUserInput.
% ------------------------------------------------------------------------------
% get the computer input by selecting a random int between 0-2
% 0 --> ROCK, 1--> PAPER, 2 --> SCISSOR
getComputerInput(UserMove):-
  random(0,3,ComputerInt),
  intToString(ComputerInt, ComputerMove),
  roundWinner(UserMove, ComputerMove).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                     PART B- Check for Winner
% Arriving here, we know taht our user input is valid, so this section will
% check for the person who won.
% The section has 3 possibility:
% 1. tie, meaning user move is same as ComputerMove
% 2. Computer wins, meaning isWinner will return true in the combination
%    of the facts outline in the FACTS section
% 3. If none, then that means user wins.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Case if the user and computer input are the same -- TIES
roundWinner(UserMove, UserMove):-
  write('You entered '),
  write(UserMove),
  write('  Computer chose '),
  write(UserMove),
  write('  '),
  write('TIE'),
  myScore(PlayerScore, ComputerScore, Tie),
  NewTie is Tie + 1,
  retract(myScore(_,_,_)),
  assert(myScore(PlayerScore,ComputerScore, NewTie)),
  nl,
  nl.

% Case if the Computer score is one of these 3 options.
%     1. isWinner("ROCK", "SCISSOR").
%     2. isWinner("SCISSOR", "PAPER").
%     3. isWinner("PAPER", "ROCK").
roundWinner(UserMove, ComputerMove):-
  isWinner(ComputerMove, UserMove),
  write('You entered '),
  write(UserMove),
  write('  Computer chose '),
  write(ComputerMove),
  write('  '),
  write('Winner is COMPUTER'),
  myScore(PlayerScore, ComputerScore, Tie),
  NewComputerScore is ComputerScore + 1,
  retract(myScore(_,_,_)),
  assert(myScore(PlayerScore,NewComputerScore, Tie)),
  nl,
  nl.

% If none of the above are true, then User wins.
roundWinner(UserMove, ComputerMove):-
  write('You entered '),
  write(UserMove),
  write('  Computer chose '),
  write(ComputerMove),
  write('  '),
  write('Winner is YOU'),
  myScore(PlayerScore, ComputerScore, Tie),
  NewPlayerScore is PlayerScore + 1,
  retract(myScore(_,_,_)),
  assert(myScore(NewPlayerScore,ComputerScore, Tie)),
  nl,
  nl.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       PART C- Print output of program(who won, user, computer and ties points)
% Arriving here means that our gameFinish has reached the end of 10 rounds.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% endGame :- does not take any input and simply print the end message
%            with the scores.
endGame:-
  myScore(PlayerScore, ComputerScore,Ties),
  write( 'Game over! You won '),
  write(PlayerScore),
  write( '  ,computer won '),
  write(ComputerScore),
  write(' ,tied '),
  write(Ties),
  write(' rounds'),
  nl,
  checkWinner.

% checkWinner :- returns true if one of these cases are satified
%                1. User wins (meaning playerscore > computerscore)
%                2. Computer wins (meaning playerscore < computerscore)
%                3. Ties, meaning both scores are the same
checkWinner:-
  myScore(PlayerScore, ComputerScore,_),
  PlayerScore > ComputerScore,
  write('Champion: YOU').

checkWinner:-
  myScore(PlayerScore, ComputerScore,_),
  PlayerScore < ComputerScore,
  write('Champion: COMPUTER').

checkWinner:-
  myScore(PlayerScore, ComputerScore,_),
  PlayerScore == ComputerScore,
  write('No one wins! It is a tie!').

% END
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Small Notes:
% When making this program, tried to make it as logical as possible. However,
% as you will see through it, some parts require a specific order. For instance
% the game has to start by someone doing "play" in order for the game to start.
% Furthermore, gameRounds needs to be exuted first, then follow the sequence of
% getting the user input, checking the input, check winner, then return
% back to gameLoop, update the rounds, check if it is equal to 10 (base case),
% otherwise, call ourselves back up again. That is the overall flow of the
% program.

% However, I would like to not that although it seems to be very functional,
% the predicates are written in a logical way in which sense I have seperate
% them in cases. And score is also initialized as a fact that is updated
% dynamically instead of being passed through as a parameter.



% Run game on MAC
%consult('/Users/arnoldgihozo/desktop/RockPaperScissor.pl').

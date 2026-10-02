import 'blackjack.dart';
import 'game.dart';
import 'guess_the_number.dart';
import 'hangman.dart';
import 'memory.dart';
import 'minesweeper.dart';
import 'pig.dart';
import 'rock_paper_scissors.dart';
import 'snake.dart';
import 'tic_tac_toe.dart';
import 'word_scramble.dart';

/// Every game in the order shown in the games list.
///
/// To add a game, implement [Game] and add an instance here.
final List<Game> allGames = [
  GuessTheNumber(),
  RockPaperScissors(),
  Memory(),
  TicTacToe(),
  Hangman(),
  WordScramble(),
  Blackjack(),
  Pig(),
  Snake(),
  Minesweeper(),
];

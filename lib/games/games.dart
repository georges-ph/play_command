import 'game.dart';
import 'guess_the_number.dart';
import 'memory.dart';
import 'rock_paper_scissors.dart';
import 'tic_tac_toe.dart';

/// Every game in the order shown in the games list.
///
/// To add a game, implement [Game] and add an instance here.
final List<Game> allGames = [
  GuessTheNumber(),
  RockPaperScissors(),
  Memory(),
  TicTacToe(),
];

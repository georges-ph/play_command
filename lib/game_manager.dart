import 'dart:io';

import 'package:dart_console/dart_console.dart';

import 'enums/actions.dart';
import 'enums/games.dart';
import 'games/game.dart';
import 'games/guess_the_number.dart';
import 'games/memory.dart';
import 'games/rock_paper_scissors.dart';
import 'games/tic_tac_toe.dart';

class GameManager extends Console {
  static final GameManager instance = GameManager._internal();

  GameManager._internal();

  void gamesList() {
    print("\n-------------------- GAMES LIST --------------------\n");
    for (final (i, game) in Games.values.indexed) {
      print("${i + 1}. ${game.gameName}");
    }
  }

  Game chooseGame() {
    _rawMode = false;
    int? number;
    do {
      stdout.write("Choose your game: ");
      number = int.tryParse(stdin.readLineSync() ?? "");
    } while (number == null || number - 1 < 0 || number - 1 >= Games.values.length);

    return switch (Games.values[number - 1]) {
      Games.guessTheNumber => GuessTheNumber(),
      Games.rockPaperScissors => RockPaperScissors(),
      Games.memoryGame => Memory(),
      Games.ticTacToe => TicTacToe()
    };
  }

  Actions endOfGame() {
    // Display actions list
    String text = "\n--------------------\n";
    for (var action in Actions.values.skip(1)) {
      text += "${action.name}: ${action.actionName}\n";
    }
    text += "--------------------\n";
    print(text);

    hideCursor();

    // Read action key
    Actions action = Actions.none;
    _rawMode = true;
    do {
      String input = String.fromCharCode(stdin.readByteSync());
      action = Actions.values.singleWhere(
        (element) => element.name == input,
        orElse: () => Actions.none,
      );
    } while (action == Actions.none);
    _rawMode = false;

    showCursor();

    return action;
  }

  /// Set terminal to raw mode.
  ///
  /// If [enabled] is `true`, it makes pressing on a keyboard key fire some logic.
  /// Otherwise, it just keeps the terminal's original values.
  set _rawMode(bool enabled) {
    if (enabled) {
      stdin.echoMode = false;
      stdin.lineMode = false;
    } else {
      stdin.lineMode = true;
      stdin.echoMode = true;
    }
  }
}

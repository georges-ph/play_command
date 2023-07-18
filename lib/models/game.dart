import 'dart:io';

import 'package:play_command/enums/action.dart';
import 'package:play_command/enums/games.dart';
import 'package:play_command/play_command.dart';

class Game {
  static final Game instance = Game._internal();

  Game._internal();

  void displayList() {
    print("\n-------------------- GAMES LIST --------------------\n");
    for (var (i, game) in Games.values.indexed) {
      print("${i + 1}. ${game.name}");
    }
  }

  /// Set terminal to raw mode.
  ///
  /// If [enabled] is `true`, it makes pressing on a keyboard key fire some logic.
  /// Otherwise, it just keeps the terminal's original values.
  set rawMode(bool enabled) {
    if (enabled) {
      stdin.echoMode = false;
      stdin.lineMode = false;
    } else {
      stdin.lineMode = true;
      stdin.echoMode = true;
    }
  }

  void start() {
    displayList();
    rawMode = false;

    // Prompt for game number
    String? input;
    int? number;
    do {
      stdout.write("Choose your game: ");
      input = stdin.readLineSync();
      number = int.tryParse(input ?? "");
    } while (input == null ||
        number == null ||
        number - 1 < 0 ||
        number - 1 >= Games.values.length);

    Games game = Games.values[number - 1];
    playGame(game);
  }

  void playGame(Games game) {
    print("\n--------------------\n");

    switch (game) {
      case Games.guess_the_number:
        guessTheNumber();
        break;

      case Games.rock_paper_scissors:
        rockPaperScissors();
        break;
    }
  }

  void endOfGame(Games game) {
    String text = "\n--------------------\n";
    for (var action in Actions.values.skip(1)) {
      text += "${action.name}: ${action.actionName}\n";
    }
    text += "--------------------\n";
    print(text);

    Actions action = Actions.none;
    do {
      rawMode = true;
      String input = String.fromCharCode(stdin.readByteSync());
      rawMode = false;

      action = Actions.values.singleWhere(
        (element) => element.name == input,
        orElse: () => Actions.none,
      );
    } while (action == Actions.none);

    switch (action) {
      case Actions.l:
        start();
        break;

      case Actions.n:
        playGame(game);
        break;

      case Actions.x:
        exit(0);

      default:
    }
  }
}

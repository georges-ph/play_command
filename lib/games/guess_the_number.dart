import 'dart:io';
import 'dart:math';

import 'game.dart';

class GuessTheNumber implements Game {
  int _answer = Random().nextInt(1001);
  int _guesses = 0;
  bool _guessed = false;

  @override
  void reset() {
    _answer = Random().nextInt(1001);
    _guesses = 0;
    _guessed = false;
  }

  @override
  void play() {
    print("----- GUESS THE NUMBER -----");
    print("Choose a number between 0 and 1000");

    while (!_guessed) {
      stdout.write("\nYour guess: ");
      int? number = int.tryParse(stdin.readLineSync() ?? "");
      if (number == null) continue;
      _guessed = _guess(number);
    }

    print("\nIt took you $_guesses guesses");
  }

  bool _guess(int number) {
    _guesses++;

    if (number < _answer) {
      print("HIGHER");
      return false;
    } else if (number > _answer) {
      print("lower");
      return false;
    } else {
      print("YOU GUESSED IT RIGHT!");
      return true;
    }
  }
}

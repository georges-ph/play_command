import 'dart:io';
import 'dart:math';

import '../game_manager.dart';
import 'game.dart';

class Memory implements Game {
  List<int> _sequence = [];
  final int _sequenceLength = 5;

  @override
  void reset() {
    _sequence = [];
  }

  @override
  void play() {
    print("----- MEMORY GAME -----");
    print(
        "You will be shown a list of numbers where you will have 3 seconds to memorize and try to guess them. (Enter the numbers directly without spaces)\n");

    sleep(Duration(seconds: 3));

    print("Starting in...");
    int count = 3;
    while (count != 0) {
      print(count.toString());
      sleep(Duration(seconds: 1));
      GameManager.instance
        ..cursorUp()
        ..eraseLine();
      count--;
    }

    GameManager.instance
      ..cursorUp()
      ..eraseLine();

    List<int> sequence = _generateSequence();
    print(sequence.join(" "));
    sleep(Duration(seconds: 3));
    GameManager.instance
      ..cursorUp()
      ..eraseLine();

    print("What was the sequence?");
    String? input;
    do {
      input = stdin.readLineSync();
    } while (input == null);

    stdout.writeln();

    if (input == sequence.join()) {
      print("You are correct!");
    } else {
      print("Incorrect sequence. The sequence was: ${sequence.join(" ")}");
    }
  }

  /// Generates a sequence of numbers from 1 to 9
  List<int> _generateSequence() {
    for (var i = 0; i < _sequenceLength; i++) {
      int randomNumber = Random().nextInt(9) + 1;
      _sequence.add(randomNumber);
    }
    return _sequence;
  }
}

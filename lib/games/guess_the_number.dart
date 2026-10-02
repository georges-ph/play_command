import 'dart:math';

import '../terminal.dart';
import 'game.dart';

class GuessTheNumber extends Game {
  static const int max = 1000;

  final Random _random;

  GuessTheNumber([Random? random]) : _random = random ?? Random();

  @override
  String get name => "Guess the Number";

  @override
  String get description => "Find the secret number with higher/lower hints";

  @override
  void play() {
    header(name);
    print("Choose a number between 0 and $max");

    final answer = _random.nextInt(max + 1);
    var guesses = 0;

    while (true) {
      final guess = promptInt("\nYour guess: ", min: 0, max: max);
      guesses++;

      if (guess < answer) {
        print("Higher!");
      } else if (guess > answer) {
        print("Lower!");
      } else {
        print(colored("YOU GUESSED IT RIGHT!", ConsoleColor.green));
        break;
      }
    }

    print("\nIt took you $guesses ${guesses == 1 ? "guess" : "guesses"}");
    return;
  }
}

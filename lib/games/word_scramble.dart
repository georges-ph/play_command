import 'dart:math';

import '../terminal.dart';
import 'game.dart';
import 'words.dart';

/// Shuffles the letters of [word], making sure the result differs from it.
String scramble(String word, Random random) {
  if (word.split("").toSet().length < 2) return word;
  String result;
  do {
    result = (word.split("")..shuffle(random)).join();
  } while (result == word);
  return result;
}

class WordScramble extends Game {
  static const int rounds = 5;
  static const int triesPerWord = 3;

  final Random _random;

  WordScramble([Random? random]) : _random = random ?? Random();

  @override
  String get name => "Word Scramble";

  @override
  String get description => "Unscramble $rounds words, $triesPerWord tries each";

  @override
  void play() {
    header(name);
    print("Unscramble the letters to find the word. Type '?' to reveal the first letter.\n");

    final picks = (List.of(words.toSet())..shuffle(_random)).take(rounds);
    var solved = 0;

    for (final (i, word) in picks.indexed) {
      print("Word ${i + 1}/$rounds: ${scramble(word, _random).toUpperCase()}");
      var hinted = false;

      for (var tries = triesPerWord; tries > 0;) {
        final guess = prompt("Your answer: ").toLowerCase();
        if (guess == "?") {
          if (!hinted) print("It starts with '${word[0].toUpperCase()}'.");
          hinted = true;
          continue;
        }
        if (guess == word) {
          print(colored("Correct!\n", ConsoleColor.green));
          solved++;
          break;
        }
        tries--;
        print(tries > 0 ? "Nope, $tries ${tries == 1 ? "try" : "tries"} left." : "The word was '$word'.\n");
      }
    }

    print("You solved $solved of $rounds words.");
  }
}

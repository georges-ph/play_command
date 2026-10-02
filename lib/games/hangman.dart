import 'dart:math';

import '../terminal.dart';
import 'game.dart';
import 'words.dart';

/// The state of one Hangman round.
class HangmanRound {
  static const int maxMistakes = 6;

  final String word;
  final Set<String> guessed = {};

  HangmanRound(this.word);

  /// Wrong letters and wrong whole-word guesses.
  Iterable<String> get misses => guessed.where((guess) => guess.length > 1 ? guess != word : !word.contains(guess));

  int get mistakes => misses.length;

  bool get isWon => word.split("").every(guessed.contains);

  bool get isLost => mistakes >= maxMistakes;

  /// The word with unguessed letters hidden, e.g. `_ a _ _ a _`.
  String get masked => word.split("").map((letter) => guessed.contains(letter) ? letter : "_").join(" ");
}

class Hangman extends Game {
  static const List<String> _gallows = [
    "  +---+\n  |   |\n      |\n      |\n      |\n      |\n=========",
    "  +---+\n  |   |\n  O   |\n      |\n      |\n      |\n=========",
    "  +---+\n  |   |\n  O   |\n  |   |\n      |\n      |\n=========",
    "  +---+\n  |   |\n  O   |\n /|   |\n      |\n      |\n=========",
    "  +---+\n  |   |\n  O   |\n /|\\  |\n      |\n      |\n=========",
    "  +---+\n  |   |\n  O   |\n /|\\  |\n /    |\n      |\n=========",
    "  +---+\n  |   |\n  O   |\n /|\\  |\n / \\  |\n      |\n=========",
  ];

  final Random _random;

  Hangman([Random? random]) : _random = random ?? Random();

  @override
  String get name => "Hangman";

  @override
  String get description => "Guess the word one letter at a time";

  @override
  void play() {
    header(name);
    final round = HangmanRound(words[_random.nextInt(words.length)]);

    while (!round.isWon && !round.isLost) {
      print(_gallows[round.mistakes]);
      print("\nWord: ${round.masked}");
      final wrong = round.misses;
      if (wrong.isNotEmpty) print("Wrong letters: ${wrong.join(" ")}");

      final input = prompt("\nGuess a letter (or the whole word): ").toLowerCase();
      if (input.length > 1) {
        if (input == round.word) {
          round.guessed.addAll(input.split(""));
        } else {
          print("Not the word!");
          round.guessed.add(input); // a wrong word counts as a mistake
        }
      } else if (!RegExp(r"^[a-z]$").hasMatch(input)) {
        print("Please type a letter.");
      } else if (!round.guessed.add(input)) {
        print("You already tried '$input'.");
      }
      print("");
    }

    if (round.isWon) {
      print(colored("You saved him! The word was '${round.word}'.", ConsoleColor.green));
      return;
    }
    print(_gallows.last);
    print(colored("\nHanged! The word was '${round.word}'.", ConsoleColor.red));
  }
}

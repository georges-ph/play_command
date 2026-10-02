import 'dart:math';

import '../terminal.dart';
import 'game.dart';

enum Weapon {
  rock,
  paper,
  scissors;

  /// Whether this weapon beats [other].
  bool beats(Weapon other) => switch (this) {
    rock => other == scissors,
    paper => other == rock,
    scissors => other == paper,
  };

  /// Parses a full name or first letter, e.g. `r` or `Rock`.
  static Weapon? parse(String input) {
    final text = input.trim().toLowerCase();
    if (text.isEmpty) return null;
    for (final weapon in values) {
      if (weapon.name == text || weapon.name[0] == text) return weapon;
    }
    return null;
  }
}

class RockPaperScissors extends Game {
  /// Number of round wins needed to win the match (best of 3).
  static const int winsNeeded = 2;

  final Random _random;

  RockPaperScissors([Random? random]) : _random = random ?? Random();

  @override
  String get name => "Rock, Paper, Scissors";

  @override
  String get description => "Best of 3 against the computer";

  @override
  void play() {
    header(name);

    var playerScore = 0, computerScore = 0, round = 1;

    while (playerScore < winsNeeded && computerScore < winsNeeded) {
      print("\n----- ROUND $round -----");
      for (final weapon in Weapon.values) {
        print("${weapon.name[0]}: ${weapon.name}");
      }

      Weapon? player;
      while (player == null) {
        player = Weapon.parse(prompt("\nChoose your weapon: "));
        if (player == null) print("Type r, p or s.");
      }
      final computer = Weapon.values[_random.nextInt(Weapon.values.length)];

      print("\nYou: ${player.name}\nComputer: ${computer.name}\n");

      if (player == computer) {
        print("It's a tie! Replaying the round.");
      } else if (player.beats(computer)) {
        print(colored("You won the round!", ConsoleColor.green));
        playerScore++;
        round++;
      } else {
        print(colored("You lost the round!", ConsoleColor.red));
        computerScore++;
        round++;
      }
    }

    print("\n---------------\n");
    print("Your score: $playerScore");
    print("Computer's score: $computerScore\n");

    if (playerScore > computerScore) {
      print(colored("You defeated the computer!", ConsoleColor.green));
      return;
    }
    print(colored("The computer defeated you.", ConsoleColor.red));
    return;
  }
}

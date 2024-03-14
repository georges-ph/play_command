import 'dart:io';

import '../enums/rock_paper_scissors.dart' as rps;
import 'game.dart';

class RockPaperScissors implements Game {
  int _playerScore = 0, _computerScore = 0;
  int _rounds = 1;

  @override
  void reset() {
    _playerScore = 0;
    _computerScore = 0;
    _rounds = 1;
  }

  @override
  void play() {
    print("----- ROCK PAPER SCISSORS -----");

    // Play the game for 3 rounds
    while (_rounds <= 3) {
      _loop();
    }

    print("\n---------------\n");

    print("Your score: $_playerScore");
    print("Computer's score: $_computerScore");

    stdout.writeln();

    if (_playerScore > _computerScore) {
      print("You defeated the computer");
    } else {
      print("The computer defeated you");
    }
  }

  void _loop() {
    final userWeapon = _chooseWeapon();
    final computerWeapon = rps.RockPaperScissors.randomWeapon;

    print("\nYou: ${userWeapon.name}\nComputer: ${computerWeapon.name}");

    stdout.writeln();

    if (computerWeapon == userWeapon) {
      print("It's a tie!");
    } else if ((computerWeapon == rps.RockPaperScissors.rock && userWeapon == rps.RockPaperScissors.paper) ||
        (computerWeapon == rps.RockPaperScissors.paper && userWeapon == rps.RockPaperScissors.scissors) ||
        (computerWeapon == rps.RockPaperScissors.scissors && userWeapon == rps.RockPaperScissors.rock)) {
      print("You won!");
      _playerScore++;
      _rounds++;
    } else {
      print("You lose!");
      _computerScore++;
      _rounds++;
    }
  }

  rps.RockPaperScissors _chooseWeapon() {
    // Display weapons list
    String text = "\n----- ROUND $_rounds -----\n";
    for (final weapon in rps.RockPaperScissors.values) {
      text += "${weapon.name.substring(0, 1)}: ${weapon.name}\n";
    }
    print(text);

    // Ask user for weapon
    stdout.write("Choose your weapon: ");
    String? input;
    do {
      input = stdin.readLineSync();
    } while (input == null);

    return rps.RockPaperScissors.values.singleWhere(
      (element) => element.name.toLowerCase().substring(0, 1) == input,
      orElse: () => rps.RockPaperScissors.randomWeapon,
    );
  }
}

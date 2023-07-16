import 'dart:io';
import 'dart:math';

import 'package:play_command/enums/rock_paper_scissors.dart';

class RockPaperScissorsGame {
  int _playerScore = 0, _computerScore = 0;
  int _rounds = 3;

  int get playerScore => _playerScore;
  int get computerScore => _computerScore;
  int get rounds => _rounds;

  RockPaperScissors chooseWeapon() {
    // Display weapons list
    String text = "\n";
    for (var weapon in RockPaperScissors.values) {
      if (weapon == RockPaperScissors.none) continue;
      text += "${weapon.name.substring(0, 1)}: ${weapon.name}\n";
    }
    print(text);

    // Ask user for weapon
    stdout.write("\nChoose your weapon: ");
    String? input;
    do {
      input = stdin.readLineSync();
    } while (input == null);

    return RockPaperScissors.values.skip(1).singleWhere(
          (element) => element.name.toLowerCase().substring(0, 1) == input,
          orElse: () => RockPaperScissors.none,
        );
  }

  void play(RockPaperScissors weapon) {
    RockPaperScissors computerWeapon = RockPaperScissors.values
        .skip(1)
        .elementAt(Random().nextInt(RockPaperScissors.values.skip(1).length));

    print("You: ${weapon.name}\nComputer: ${computerWeapon.name}");

    if (computerWeapon == weapon) {
      print("It's a tie!");
    } else if (computerWeapon == RockPaperScissors.rock &&
            weapon == RockPaperScissors.paper ||
        computerWeapon == RockPaperScissors.paper &&
            weapon == RockPaperScissors.scissors ||
        computerWeapon == RockPaperScissors.scissors &&
            weapon == RockPaperScissors.rock) {
      print("You won!");
      _playerScore++;
      _rounds--;
    } else {
      print("You lose!");
      _computerScore++;
      _rounds--;
    }
  }
}

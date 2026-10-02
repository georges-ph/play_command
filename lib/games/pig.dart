import 'dart:io';
import 'dart:math';

import '../terminal.dart';
import 'game.dart';

class Pig extends Game {
  static const int target = 50;

  /// The computer banks its turn once it has this many points.
  static const int computerHoldAt = 15;

  final Random _random;

  Pig([Random? random]) : _random = random ?? Random();

  @override
  String get name => "Pig (Dice)";

  @override
  String get description => "Dice race to $target, but a 1 loses your turn";

  @override
  void play() {
    header(name);
    print("Roll a die as often as you like and add up the points.");
    print("Hold to bank them, but roll a 1 and you lose the whole turn.");
    print("First to $target wins!\n");

    var you = 0, computer = 0;

    while (true) {
      you += _playerTurn(you);
      print("Score: you $you, computer $computer\n");
      if (you >= target) {
        print(colored("You win!", ConsoleColor.green));
        return;
      }

      computer += _computerTurn(computer, you);
      print("Score: you $you, computer $computer\n");
      if (computer >= target) {
        print(colored("The computer wins.", ConsoleColor.red));
        return;
      }
    }
  }

  int _roll() => _random.nextInt(6) + 1;

  int _playerTurn(int score) {
    print("-- Your turn --");
    var turn = 0;
    while (true) {
      final choice = promptChoice("Turn total $turn. (r)oll or (h)old? ", ["r", "h", "roll", "hold"]);
      if (choice.startsWith("h")) return turn;
      final roll = _roll();
      if (roll == 1) {
        print(colored("You rolled a 1. Turn over!", ConsoleColor.red));
        return 0;
      }
      turn += roll;
      print("You rolled a $roll.");
      if (score + turn >= target) return turn;
    }
  }

  int _computerTurn(int score, int opponent) {
    print("-- Computer's turn --");
    // Takes more risk when it's far behind.
    final holdAt = opponent - score > 20 ? computerHoldAt + 10 : computerHoldAt;
    var turn = 0;
    while (turn < holdAt && score + turn < target) {
      sleep(const Duration(milliseconds: 600));
      final roll = _roll();
      if (roll == 1) {
        print("Computer rolled a 1. Turn over!");
        return 0;
      }
      turn += roll;
      print("Computer rolled a $roll (turn total $turn).");
    }
    print("Computer holds with $turn.");
    return turn;
  }
}

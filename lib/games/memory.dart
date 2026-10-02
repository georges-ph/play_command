import 'dart:io';
import 'dart:math';

import '../terminal.dart';
import 'game.dart';

class Memory extends Game {
  static const int startLength = 3;

  final Random _random;

  Memory([Random? random]) : _random = random ?? Random();

  @override
  String get name => "Memory Game";

  @override
  String get description => "Remember ever-longer number sequences";

  @override
  void play() {
    header(name);
    print("Memorize the numbers shown, then type them back without spaces.");
    print("Each correct answer adds one more number.\n");
    sleep(const Duration(seconds: 2));

    var length = startLength;
    var best = 0;

    while (true) {
      _countdown();

      final sequence = List.generate(length, (_) => _random.nextInt(9) + 1);
      print(sequence.join(" "));
      sleep(Duration(milliseconds: 1500 + 500 * length));
      _eraseLastLine();

      final input = prompt("What was the sequence? ").replaceAll(" ", "");

      if (input != sequence.join()) {
        print(colored("\nIncorrect. The sequence was: ${sequence.join(" ")}", ConsoleColor.red));
        break;
      }

      best = length;
      print("${colored("Correct!", ConsoleColor.green)} Next: ${length + 1} numbers.\n");
      length++;
    }

    print("\nYou remembered up to $best numbers.");
    return;
  }

  void _countdown() {
    print("Starting in...");
    for (var count = 3; count > 0; count--) {
      print(count);
      sleep(const Duration(seconds: 1));
      _eraseLastLine();
    }
    _eraseLastLine();
  }

  void _eraseLastLine() => console
    ..cursorUp()
    ..eraseLine();
}

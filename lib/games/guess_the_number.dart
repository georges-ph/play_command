import 'dart:math';

class GuessTheNumberGame {
  final _answer = Random().nextInt(1001);
  int _guesses = 0;

  int get guesses => _guesses;

  bool guess(int number) {
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

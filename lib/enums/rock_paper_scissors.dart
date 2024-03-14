import 'dart:math';

enum RockPaperScissors {
  rock,
  paper,
  scissors;

  static RockPaperScissors get randomWeapon {
    int randomIndex = Random().nextInt(values.length);
    return values[randomIndex];
  }
}

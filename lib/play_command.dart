import 'dart:io';

import 'package:play_command/enums/games.dart';
import 'package:play_command/enums/rock_paper_scissors.dart';
import 'package:play_command/games/guess_the_number.dart';
import 'package:play_command/games/rock_paper_scissors.dart';
import 'package:play_command/models/game.dart';

void guessTheNumber() {
  GuessTheNumberGame guessTheNumber = GuessTheNumberGame();
  bool guessed = false;

  print("\n----- GUESS THE NUMBER -----");
  print("Choose a number between 0 and 1000");

  while (!guessed) {
    stdout.write("\nYour guess: ");
    guessed =
        guessTheNumber.guess(int.tryParse(stdin.readLineSync() ?? "") ?? -1);
  }

  print("\nIt took you ${guessTheNumber.guesses} guesses");

  Game.instance.endOfGame(Games.guess_the_number);
}

void rockPaperScissors() {
  print("\n----- ROCK PAPER SCISSORS -----");

  RockPaperScissorsGame rockPaperScissorsGame = RockPaperScissorsGame();
  RockPaperScissors weapon = RockPaperScissors.none;

  while (rockPaperScissorsGame.rounds != 0) {
    do {
      weapon = rockPaperScissorsGame.chooseWeapon();
    } while (weapon == RockPaperScissors.none);
    rockPaperScissorsGame.play(weapon);
  }

  print("Your score: ${rockPaperScissorsGame.playerScore}");
  print("Computer's score: ${rockPaperScissorsGame.computerScore}");

  if (rockPaperScissorsGame.playerScore > rockPaperScissorsGame.computerScore) {
    print("You defeated the computer");
  } else {
    print("The computer defeated you");
  }

  Game.instance.endOfGame(Games.rock_paper_scissors);
}

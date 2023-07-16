import 'dart:io';

import 'package:play_command/enums/games.dart';
import 'package:play_command/games/guess_the_number.dart';
import 'package:play_command/models/game.dart';

void guessTheNumber() {
  GuessTheNumber guessTheNumber = GuessTheNumber();
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

void rockPaperScissors() {}

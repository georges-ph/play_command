import 'dart:io';

import 'package:play_command/enums/games.dart';
import 'package:play_command/enums/rock_paper_scissors.dart';
import 'package:play_command/games/guess_the_number.dart';
import 'package:play_command/games/memory_game.dart';
import 'package:play_command/games/rock_paper_scissors.dart';
import 'package:play_command/models/game.dart';
import 'package:play_command/models/game_console.dart';

void guessTheNumber() {
  GuessTheNumberGame guessTheNumber = GuessTheNumberGame();
  bool guessed = false;

  print("----- GUESS THE NUMBER -----");
  print("Choose a number between 0 and 1000");

  while (!guessed) {
    stdout.write("\nYour guess: ");
    int? number = int.tryParse(stdin.readLineSync() ?? "");
    if (number == null) continue;
    guessed = guessTheNumber.guess(number);
  }

  print("\nIt took you ${guessTheNumber.guesses} guesses");

  Game.instance.endOfGame(Games.guess_the_number);
}

void rockPaperScissors() {
  print("----- ROCK PAPER SCISSORS -----");

  RockPaperScissorsGame rockPaperScissorsGame = RockPaperScissorsGame();
  RockPaperScissors weapon = RockPaperScissors.none;

  while (rockPaperScissorsGame.rounds <= 3) {
    do {
      weapon = rockPaperScissorsGame.chooseWeapon();
    } while (weapon == RockPaperScissors.none);
    rockPaperScissorsGame.play(weapon);
  }

  print("\n---------------\n");

  print("Your score: ${rockPaperScissorsGame.playerScore}");
  print("Computer's score: ${rockPaperScissorsGame.computerScore}");

  stdout.writeln();

  if (rockPaperScissorsGame.playerScore > rockPaperScissorsGame.computerScore) {
    print("You defeated the computer");
  } else {
    print("The computer defeated you");
  }

  Game.instance.endOfGame(Games.rock_paper_scissors);
}

void memoryGame() {
  print("----- MEMORY GAME -----");

  MemoryGame memoryGame = MemoryGame();

  print(
      "You will be shown a list of numbers where you will have 3 seconds to memorize and try to guess them. (Enter the numbers directly without spaces)\n");

  sleep(Duration(seconds: 3));

  print("Starting in...");
  int count = 3;
  while (count != 0) {
    print(count.toString());
    sleep(Duration(seconds: 1));
    GameConsole.instance
      ..cursorUp()
      ..eraseLine();
    count--;
  }

  GameConsole.instance
    ..cursorUp()
    ..eraseLine();

  List<int> sequence = memoryGame.generateSequence();
  print(sequence.join(" "));
  sleep(Duration(seconds: 3));
  GameConsole.instance
    ..cursorUp()
    ..eraseLine();

  print("What was the sequence?");
  String? input;
  do {
    input = stdin.readLineSync();
  } while (input == null);

  stdout.writeln();

  if (input == sequence.join()) {
    print("You are correct!");
  } else {
    print("Incorrect sequence. The sequence was: ${sequence.join(" ")}");
  }

  Game.instance.endOfGame(Games.memory_game);
}

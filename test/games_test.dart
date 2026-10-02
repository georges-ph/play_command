import 'dart:math';

import 'package:play_command/games/blackjack.dart';
import 'package:play_command/games/games.dart';
import 'package:play_command/games/hangman.dart';
import 'package:play_command/games/minesweeper.dart';
import 'package:play_command/games/snake.dart';
import 'package:play_command/games/word_scramble.dart';
import 'package:play_command/games/words.dart';
import 'package:test/test.dart';

void main() {
  test("game names are unique", () {
    final names = allGames.map((game) => game.name);
    expect(names.toSet().length, names.length);
  });

  group("Blackjack", () {
    PlayingCard card(String rank) => PlayingCard(rank, 0);

    test("face cards count 10", () {
      expect(handValue([card("K"), card("Q")]), 20);
    });

    test("aces count 11 or 1", () {
      expect(handValue([card("A"), card("K")]), 21);
      expect(handValue([card("A"), card("A")]), 12);
      expect(handValue([card("A"), card("9"), card("5")]), 15);
      expect(handValue([card("A"), card("A"), card("K"), card("9")]), 21);
    });
  });

  group("Hangman", () {
    test("tracks mistakes and win/loss", () {
      final round = HangmanRound("dart");
      round.guessed.addAll(["d", "a", "x"]);
      expect(round.masked, "d a _ _");
      expect(round.mistakes, 1);
      expect(round.isWon, isFalse);
      round.guessed.addAll(["r", "t"]);
      expect(round.isWon, isTrue);
    });

    test("loses after too many mistakes", () {
      final round = HangmanRound("dart")..guessed.addAll(["b", "c", "e", "f", "g", "h"]);
      expect(round.isLost, isTrue);
    });
  });

  group("Word Scramble", () {
    test("scrambled word is a different arrangement of the same letters", () {
      final random = Random(42);
      for (final word in words) {
        final result = scramble(word, random);
        expect(result, isNot(word));
        expect((result.split("")..sort()).join(), (word.split("")..sort()).join());
      }
    });
  });

  group("Minesweeper", () {
    test("first reveal is never a mine", () {
      for (var seed = 0; seed < 50; seed++) {
        final field = Minefield(random: Random(seed))..reveal(4, 4);
        expect(field.exploded, isFalse);
        expect(field.mines.expand((row) => row).where((m) => m).length, 10);
      }
    });

    test("flood-fills empty areas and detects a cleared field", () {
      final field = Minefield(rows: 3, cols: 3, mineCount: 1)..placeMines([(0, 0)]);
      field.reveal(2, 2);
      expect(field.isCleared, isTrue);
      expect(field.revealed[0][0], isFalse);
    });

    test("revealing a mine explodes, flags protect cells", () {
      final field = Minefield(rows: 3, cols: 3, mineCount: 1)..placeMines([(0, 0)]);
      field.toggleFlag(0, 0);
      field.reveal(0, 0);
      expect(field.exploded, isFalse);
      field.toggleFlag(0, 0);
      field.reveal(0, 0);
      expect(field.exploded, isTrue);
    });
  });

  group("Snake", () {
    test("moves, cannot reverse, and dies at the wall", () {
      final snake = SnakeState(rows: 5, cols: 6, random: Random(1));
      snake.food = (0, 0); // keep food out of the way
      snake.turn(Direction.left); // reversing is ignored
      snake.step();
      expect(snake.body.first, (2, 4));
      snake.step();
      expect(snake.body.first, (2, 5));
      snake.step();
      expect(snake.dead, isTrue);
    });

    test("grows when eating", () {
      final snake = SnakeState(rows: 5, cols: 10, random: Random(1));
      snake.food = (2, 4);
      snake.step();
      expect(snake.score, 1);
      expect(snake.body.length, 4);
    });
  });
}

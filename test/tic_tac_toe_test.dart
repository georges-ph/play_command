import 'dart:math';

import 'package:play_command/games/tic_tac_toe.dart';
import 'package:test/test.dart';

TicTacToeBoard board(String cells) => TicTacToeBoard()..cells.setAll(0, cells.split(""));

void main() {
  test("detects rows, columns and diagonals", () {
    expect(board("XXX      ").winner, "X");
    expect(board("O  O  O  ").winner, "O");
    expect(board("X   X   X").winner, "X");
    expect(board("  O O O  ").winner, "O");
    expect(board("XOXXOOOXX").winner, isNull);
  });

  test("detects a full board", () {
    expect(board("XOXXOOOXX").isFull, isTrue);
    expect(board("XOXXOOOX ").isFull, isFalse);
  });

  test("computer takes a winning move before blocking", () {
    expect(board("XX OO    ").bestMove("O", Random(1)), 5);
  });

  test("computer blocks the opponent", () {
    expect(board("XX  O    ").bestMove("O", Random(1)), 2);
  });

  test("computer takes the center on an empty board", () {
    expect(board("         ").bestMove("O", Random(1)), 4);
  });
}

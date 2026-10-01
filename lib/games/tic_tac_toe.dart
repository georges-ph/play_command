import 'dart:math';

import '../terminal.dart';
import 'game.dart';

/// A Tic Tac Toe board. Cells are indexed 0-8, left to right, top to bottom.
class TicTacToeBoard {
  static const List<List<int>> lines = [
    [0, 1, 2], [3, 4, 5], [6, 7, 8], // rows
    [0, 3, 6], [1, 4, 7], [2, 5, 8], // columns
    [0, 4, 8], [2, 4, 6], // diagonals
  ];

  final List<String> cells = List.filled(9, " ");

  bool isFree(int index) => cells[index] == " ";

  bool get isFull => !cells.contains(" ");

  List<int> get freeCells => [
        for (var i = 0; i < 9; i++)
          if (isFree(i)) i
      ];

  /// The symbol that has three in a row, or `null` if nobody has.
  String? get winner {
    for (final line in lines) {
      final symbol = cells[line[0]];
      if (symbol != " " && cells[line[1]] == symbol && cells[line[2]] == symbol) return symbol;
    }
    return null;
  }

  /// Picks a move for [symbol]: win if possible, otherwise block the
  /// opponent, otherwise take the center, a corner or any free cell.
  int bestMove(String symbol, Random random) {
    final opponent = symbol == "X" ? "O" : "X";
    for (final player in [symbol, opponent]) {
      for (final cell in freeCells) {
        cells[cell] = player;
        final wins = winner == player;
        cells[cell] = " ";
        if (wins) return cell;
      }
    }
    if (isFree(4)) return 4;
    final corners = [0, 2, 6, 8].where(isFree).toList();
    if (corners.isNotEmpty) return corners[random.nextInt(corners.length)];
    final free = freeCells;
    return free[random.nextInt(free.length)];
  }

  @override
  String toString() {
    final rows = [
      for (var i = 0; i < 9; i += 3) " ${cells[i]} | ${cells[i + 1]} | ${cells[i + 2]}",
    ];
    return rows.join("\n-----------\n");
  }
}

class TicTacToe extends Game {
  final Random _random;

  TicTacToe([Random? random]) : _random = random ?? Random();

  @override
  String get name => "Tic Tac Toe";

  @override
  String get description => "Three in a row, against the computer or a friend";

  @override
  GameOutcome play() {
    header(name);
    print("1. Play against the computer");
    print("2. Two players");
    final vsComputer = promptInt("Choose a mode: ", min: 1, max: 2) == 1;

    print("\nCells are numbered like a phone keypad:");
    print(" 1 | 2 | 3\n-----------\n 4 | 5 | 6\n-----------\n 7 | 8 | 9\n");

    final board = TicTacToeBoard();
    var current = "X";

    while (board.winner == null && !board.isFull) {
      if (vsComputer && current == "O") {
        final move = board.bestMove("O", _random);
        board.cells[move] = "O";
        print("Computer plays ${move + 1}");
      } else {
        final label = vsComputer ? "Your move" : "Player $current";
        var move = promptInt("$label (1-9): ", min: 1, max: 9) - 1;
        while (!board.isFree(move)) {
          print("That cell is taken.");
          move = promptInt("$label (1-9): ", min: 1, max: 9) - 1;
        }
        board.cells[move] = current;
      }

      print("\n$board\n");
      current = current == "X" ? "O" : "X";
    }

    final winner = board.winner;
    if (winner == null) {
      print("It's a tie!");
      return GameOutcome(vsComputer ? GameResult.draw : GameResult.none);
    }
    if (!vsComputer) {
      print("Player $winner won!");
      return const GameOutcome(GameResult.none);
    }
    if (winner == "X") {
      print(colored("You won!", ConsoleColor.green));
      return const GameOutcome(GameResult.win);
    }
    print(colored("The computer won.", ConsoleColor.red));
    return const GameOutcome(GameResult.loss);
  }
}

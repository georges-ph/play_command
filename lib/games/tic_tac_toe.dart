import 'dart:io';

import 'game.dart';

class TicTacToe implements Game {
  List<String> _board = List.filled(9, " ");
  String _currentPlayer = "X";

  @override
  void reset() {
    _board = List.filled(9, " ");
    _currentPlayer = "X";
  }

  @override
  void play() {
    _printBoard();

    while (!_isBoardFull() && !_checkWin()) {
      String? input;
      do {
        stdout.write("Player $_currentPlayer: make your move (1-9): ");
        input = stdin.readLineSync();
      } while (input == null ||
          input.isEmpty ||
          int.tryParse(input) == null ||
          int.parse(input) < 1 ||
          int.parse(input) > 9);

      if (!_makeMove(int.parse(input))) {
        print("Invalid move. Try again.");
      }

      _printBoard();
    }

    if (_checkWin()) {
      print("Player $_currentPlayer won!");
    } else {
      print("It's a tie!");
    }
  }

  void _printBoard() {
    for (var i = 0; i < _board.length; i += 3) {
      print(" ${_board[i]} | ${_board[i + 1]} | ${_board[i + 2]}");
      if (i < 6) print("-----------");
    }
  }

  bool _makeMove(int position) {
    if (_board[position - 1] != " ") return false;
    _board[position - 1] = _currentPlayer;
    if (_checkWin()) return false;
    _currentPlayer = _currentPlayer == "X" ? "O" : "X";
    return true;
  }

  bool _checkWin() {
    // Check rows
    for (var i = 0; i < _board.length; i += 3) {
      if (_board[i] == _currentPlayer && _board[i + 1] == _currentPlayer && _board[i + 2] == _currentPlayer) {
        return true;
      }
    }

    // Check columns
    for (var i = 0; i < 3; i++) {
      // Adjusted loop
      if (_board[i] == _currentPlayer && _board[i + 3] == _currentPlayer && _board[i + 6] == _currentPlayer) {
        return true;
      }
    }

    // Check diagonals
    if (_board[0] == _currentPlayer && _board[4] == _currentPlayer && _board[8] == _currentPlayer) return true;

    if (_board[2] == _currentPlayer && _board[4] == _currentPlayer && _board[6] == _currentPlayer) return true;

    // Otherwise, there is a tie
    return false;
  }

  bool _isBoardFull() => _board.every((element) => element != " ");
}

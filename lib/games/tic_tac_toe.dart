class TicTacToe {
  final List<String> _board = List.filled(9, " ");
  String _currentPlayer = "X";

  String get currentPlayer => _currentPlayer;

  void printBoard() {
    for (var i = 0; i < _board.length; i += 3) {
      print(" ${_board[i]} | ${_board[i + 1]} | ${_board[i + 2]}");
      if (i < 6) print("-----------");
    }
  }

  bool makeMove(int position) {
    if (_board[position - 1] != " ") return false;
    _board[position - 1] = _currentPlayer;
    if (checkWin()) return false;
    _currentPlayer = _currentPlayer == "X" ? "O" : "X";
    return true;
  }

  bool checkWin() {
    // Check rows
    for (var i = 0; i < _board.length; i += 3) {
      if (_board[i] == _currentPlayer &&
          _board[i + 1] == _currentPlayer &&
          _board[i + 2] == _currentPlayer) return true;
    }

    // Check columns
    for (var i = 0; i < 3; i++) { // Adjusted loop
      if (_board[i] == _currentPlayer &&
          _board[i + 3] == _currentPlayer &&
          _board[i + 6] == _currentPlayer) return true;
    }

    // Check diagonals
    if (_board[0] == _currentPlayer &&
        _board[4] == _currentPlayer &&
        _board[8] == _currentPlayer) return true;

    if (_board[2] == _currentPlayer &&
        _board[4] == _currentPlayer &&
        _board[6] == _currentPlayer) return true;

    // Otherwise, there is a tie
    return false;
  }

}

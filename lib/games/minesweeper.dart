import 'dart:io';
import 'dart:math';

import '../terminal.dart';
import 'game.dart';

/// A Minesweeper field. Mines are placed on the first reveal, never on or
/// next to the first cell, so the first move is always safe.
class Minefield {
  final int rows, cols, mineCount;
  final Random _random;

  late final List<List<bool>> mines = List.generate(rows, (_) => List.filled(cols, false));
  late final List<List<bool>> revealed = List.generate(rows, (_) => List.filled(cols, false));
  late final List<List<bool>> flagged = List.generate(rows, (_) => List.filled(cols, false));

  bool _minesPlaced = false;
  bool exploded = false;

  Minefield({this.rows = 9, this.cols = 9, this.mineCount = 10, Random? random}) : _random = random ?? Random();

  Iterable<(int, int)> neighbors(int row, int col) sync* {
    for (var r = row - 1; r <= row + 1; r++) {
      for (var c = col - 1; c <= col + 1; c++) {
        if ((r != row || c != col) && r >= 0 && r < rows && c >= 0 && c < cols) yield (r, c);
      }
    }
  }

  int adjacentMines(int row, int col) => neighbors(row, col).where((cell) => mines[cell.$1][cell.$2]).length;

  /// Places mines manually (used by tests); disables random placement.
  void placeMines(Iterable<(int, int)> cells) {
    for (final (r, c) in cells) {
      mines[r][c] = true;
    }
    _minesPlaced = true;
  }

  void _placeRandomMines(int safeRow, int safeCol) {
    final safe = {(safeRow, safeCol), ...neighbors(safeRow, safeCol)};
    final candidates = [
      for (var r = 0; r < rows; r++)
        for (var c = 0; c < cols; c++)
          if (!safe.contains((r, c))) (r, c),
    ]..shuffle(_random);
    placeMines(candidates.take(mineCount));
  }

  /// Reveals a cell, flood-filling empty areas. Sets [exploded] on a mine.
  void reveal(int row, int col) {
    if (!_minesPlaced) _placeRandomMines(row, col);
    if (flagged[row][col] || revealed[row][col]) return;

    if (mines[row][col]) {
      revealed[row][col] = true;
      exploded = true;
      return;
    }

    final queue = [(row, col)];
    while (queue.isNotEmpty) {
      final (r, c) = queue.removeLast();
      if (revealed[r][c] || flagged[r][c]) continue;
      revealed[r][c] = true;
      if (adjacentMines(r, c) == 0) queue.addAll(neighbors(r, c));
    }
  }

  void toggleFlag(int row, int col) {
    if (!revealed[row][col]) flagged[row][col] = !flagged[row][col];
  }

  int get flagCount => flagged.expand((row) => row).where((f) => f).length;

  /// Won when every cell without a mine is revealed.
  bool get isCleared {
    for (var r = 0; r < rows; r++) {
      for (var c = 0; c < cols; c++) {
        if (!mines[r][c] && !revealed[r][c]) return false;
      }
    }
    return true;
  }
}

class Minesweeper extends Game {
  final Random? _random;

  Minesweeper([this._random]);

  @override
  String get name => "Minesweeper";

  @override
  String get description => "Clear the field without hitting a mine";

  @override
  void play() {
    final field = Minefield(random: _random);
    var row = field.rows ~/ 2, col = field.cols ~/ 2;
    final started = DateTime.now();

    console.hideCursor();
    try {
      while (!field.exploded && !field.isCleared) {
        _draw(field, row, col);
        final key = readKey();
        switch ((key.controlChar, key.char.toLowerCase())) {
          case (ControlCharacter.arrowUp, _) || (_, "w"):
            row = (row - 1) % field.rows;
          case (ControlCharacter.arrowDown, _) || (_, "s"):
            row = (row + 1) % field.rows;
          case (ControlCharacter.arrowLeft, _) || (_, "a"):
            col = (col - 1) % field.cols;
          case (ControlCharacter.arrowRight, _) || (_, "d"):
            col = (col + 1) % field.cols;
          case (ControlCharacter.enter, _) || (_, " "):
            field.reveal(row, col);
          case (_, "f"):
            field.toggleFlag(row, col);
          case (_, "q"):
            _draw(field, row, col, showMines: true);
            print("You gave up.");
            return;
        }
      }
    } finally {
      console.showCursor();
    }

    _draw(field, row, col, showMines: true);
    if (field.exploded) {
      print(colored("BOOM! You hit a mine.", ConsoleColor.red));
      return;
    }
    final seconds = DateTime.now().difference(started).inSeconds;
    print(colored("Field cleared in $seconds seconds!", ConsoleColor.green));
  }

  void _draw(Minefield field, int cursorRow, int cursorCol, {bool showMines = false}) {
    if (stdout.hasTerminal) console.clearScreen();
    final out = StringBuffer();
    out.writeln("----- MINESWEEPER -----\n");
    out.writeln("Arrows/WASD move, Space/Enter reveal, F flag, Q give up");
    out.writeln("Mines: ${field.mineCount}   Flags: ${field.flagCount}\n");

    for (var r = 0; r < field.rows; r++) {
      out.write("  ");
      for (var c = 0; c < field.cols; c++) {
        final cell = _cell(field, r, c, showMines);
        final selected = r == cursorRow && c == cursorCol && !showMines;
        out.write(selected ? "[$cell]" : " $cell ");
      }
      out.writeln();
    }
    out.writeln();
    stdout.write(out);
  }

  String _cell(Minefield field, int r, int c, bool showMines) {
    if (field.revealed[r][c] || (showMines && field.mines[r][c])) {
      if (field.mines[r][c]) return colored("*", ConsoleColor.red);
      final count = field.adjacentMines(r, c);
      if (count == 0) return " ";
      const colors = [ConsoleColor.blue, ConsoleColor.green, ConsoleColor.red, ConsoleColor.magenta];
      return colored("$count", colors[min(count, colors.length) - 1]);
    }
    if (field.flagged[r][c]) return colored("F", ConsoleColor.yellow);
    return ".";
  }
}

import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'dart:isolate';
import 'dart:math';

import '../terminal.dart';
import 'game.dart';

enum Direction {
  up(-1, 0),
  down(1, 0),
  left(0, -1),
  right(0, 1);

  final int dRow, dCol;

  const Direction(this.dRow, this.dCol);

  bool isOpposite(Direction other) => dRow == -other.dRow && dCol == -other.dCol;
}

/// The snake, the food and the rules, without any terminal I/O.
class SnakeState {
  final int rows, cols;
  final Random _random;

  /// Snake cells as (row, col), head first.
  final Queue<(int, int)> body = Queue();
  Direction direction = Direction.right;
  Direction _next = Direction.right;
  (int, int)? food;
  bool dead = false;
  int score = 0;

  SnakeState({this.rows = 15, this.cols = 30, Random? random}) : _random = random ?? Random() {
    final row = rows ~/ 2;
    body.addAll([(row, 3), (row, 2), (row, 1)]);
    _placeFood();
  }

  /// Queues a turn for the next [step]. Reversing into yourself is ignored.
  void turn(Direction to) {
    if (!to.isOpposite(direction)) _next = to;
  }

  /// Moves the snake one cell, eating food and checking collisions.
  void step() {
    if (dead) return;
    direction = _next;

    final (row, col) = body.first;
    final head = (row + direction.dRow, col + direction.dCol);
    final eats = head == food;

    if (!eats) body.removeLast();
    if (head.$1 < 0 || head.$1 >= rows || head.$2 < 0 || head.$2 >= cols || body.contains(head)) {
      dead = true;
      return;
    }
    body.addFirst(head);

    if (eats) {
      score++;
      _placeFood();
    }
  }

  void _placeFood() {
    final occupied = body.toSet();
    final free = [
      for (var r = 0; r < rows; r++)
        for (var c = 0; c < cols; c++)
          if (!occupied.contains((r, c))) (r, c),
    ];
    food = free.isEmpty ? null : free[_random.nextInt(free.length)];
    if (food == null) dead = true; // the board is full: nothing left to eat
  }
}

/// Runs in a background isolate: reads raw bytes from stdin and sends them to
/// the game one at a time. After each byte it waits for the game to reply
/// `true` (keep reading) or anything else (stop), so no key press is lost
/// once the game is over.
Future<void> _readKeys(SendPort out) async {
  final inbox = ReceivePort();
  out.send(inbox.sendPort);
  final replies = StreamIterator(inbox);
  while (true) {
    final byte = stdin.readByteSync();
    out.send(byte);
    if (byte == -1 || !await replies.moveNext() || replies.current != true) break;
  }
  inbox.close();
}

class Snake extends Game {
  final Random? _random;

  Snake([this._random]);

  @override
  String get name => "Snake";

  @override
  String get description => "Eat, grow, and don't bite your tail";

  @override
  Future<void> play() async {
    header(name);
    if (!stdin.hasTerminal) {
      print("Snake needs an interactive terminal.");
      return;
    }
    print("Steer with the arrow keys or WASD. Press Q to stop.");
    print("\nPress any key to start...");
    readKey();

    final state = SnakeState(random: _random);
    final fromReader = ReceivePort();
    final finished = Completer<void>();
    SendPort? toReader;
    var quitRequested = false;
    var escape = 0; // progress through an arrow key's escape sequence: ESC [ A

    console
      ..hideCursor()
      ..clearScreen();
    enterRawMode();
    _draw(state);

    fromReader.listen((message) {
      if (message is SendPort) {
        toReader = message;
        return;
      }
      final byte = message as int;
      if (state.dead || byte == -1) {
        toReader?.send(false);
        if (!finished.isCompleted) finished.complete();
        return;
      }

      final char = String.fromCharCode(byte).toLowerCase();
      if (escape == 1) {
        escape = (char == "[" || char == "o") ? 2 : 0;
      } else if (escape == 2) {
        escape = 0;
        switch (char) {
          case "a":
            state.turn(Direction.up);
          case "b":
            state.turn(Direction.down);
          case "c":
            state.turn(Direction.right);
          case "d":
            state.turn(Direction.left);
        }
      } else if (byte == 27) {
        escape = 1;
      } else if (byte == 3) {
        quitRequested = true; // Ctrl+C
        state.dead = true;
      } else {
        switch (char) {
          case "w":
            state.turn(Direction.up);
          case "s":
            state.turn(Direction.down);
          case "a":
            state.turn(Direction.left);
          case "d":
            state.turn(Direction.right);
          case "q":
            state.dead = true;
        }
      }

      if (state.dead) {
        // Stopped from the keyboard: no "press any key" needed.
        toReader?.send(false);
        if (!finished.isCompleted) finished.complete();
      } else {
        toReader?.send(true);
      }
    });

    final isolate = await Isolate.spawn(_readKeys, fromReader.sendPort);

    // Game loop: speeds up as the snake grows.
    while (!state.dead) {
      await Future.delayed(Duration(milliseconds: max(60, 150 - state.score * 4)));
      state.step();
      _draw(state);
    }
    if (!finished.isCompleted) {
      stdout.write("Game over! Press any key to continue...\r\n");
    }
    await finished.future;

    fromReader.close();
    isolate.kill();
    restoreTerminal();
    console.showCursor();
    if (quitRequested) quit();

    print("\nYou ate ${state.score} ${state.score == 1 ? "apple" : "apples"}.");
    return;
  }

  void _draw(SnakeState state) {
    final cells = state.body.toSet();
    final head = state.body.first;
    final border = "#" * (state.cols + 2);

    // Raw mode on Unix doesn't turn "\n" into a carriage return, so use "\r\n".
    final out = StringBuffer()
      ..write("Score: ${state.score}".padRight(state.cols + 2))
      ..write("\r\n$border\r\n");
    for (var r = 0; r < state.rows; r++) {
      out.write("#");
      for (var c = 0; c < state.cols; c++) {
        final cell = (r, c);
        if (cell == head) {
          out.write(colored("@", ConsoleColor.green));
        } else if (cells.contains(cell)) {
          out.write(colored("o", ConsoleColor.green));
        } else if (cell == state.food) {
          out.write(colored("*", ConsoleColor.red));
        } else {
          out.write(" ");
        }
      }
      out.write("#\r\n");
    }
    out.write("$border\r\n");

    console.resetCursorPosition();
    stdout.write(out);
  }
}

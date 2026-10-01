import 'dart:io';

import 'package:dart_console/dart_console.dart';

export 'package:dart_console/dart_console.dart' show ConsoleColor, ControlCharacter, Key;

/// Shared console used for cursor control and single key input.
final console = Console();

/// Prints a section header such as `----- HANGMAN -----`.
void header(String title) => print("\n----- ${title.toUpperCase()} -----\n");

/// Wraps [text] in ANSI color codes when the terminal supports them.
String colored(String text, ConsoleColor color) {
  if (!stdout.supportsAnsiEscapes) return text;
  return "${color.ansiSetForegroundColorSequence}$text\x1b[m";
}

/// Asks [message] until the user enters a non-empty line, and returns it trimmed.
String prompt(String message) {
  while (true) {
    stdout.write(message);
    final line = stdin.readLineSync();
    if (line == null) quit(); // stdin was closed
    if (line.trim().isNotEmpty) return line.trim();
  }
}

/// Asks [message] until the user enters a whole number between [min] and [max].
int promptInt(String message, {required int min, required int max}) {
  while (true) {
    final value = int.tryParse(prompt(message));
    if (value != null && value >= min && value <= max) return value;
    print("Please enter a number between $min and $max.");
  }
}

/// Asks [message] until the user enters one of [options] (case-insensitive),
/// and returns the matching option.
String promptChoice(String message, List<String> options) {
  while (true) {
    final input = prompt(message).toLowerCase();
    for (final option in options) {
      if (option.toLowerCase() == input) return option;
    }
    print("Please enter one of: ${options.join(", ")}.");
  }
}

/// Reads a single key press without waiting for Enter. Quits on Ctrl+C.
Key readKey() {
  if (!stdin.hasTerminal) {
    // Piped input: treat each byte as a key press.
    int byte;
    do {
      byte = stdin.readByteSync();
      if (byte == -1) quit();
    } while (byte == 10 || byte == 13);
    return Key.printable(String.fromCharCode(byte));
  }

  final key = console.readKey();
  restoreTerminal();
  if (key.controlChar == ControlCharacter.ctrlC) quit();
  return key;
}

/// Puts the terminal back into normal line-by-line input with echo.
///
/// dart_console 1.2.0 clears every input flag on Windows when it leaves raw
/// mode, so line input and echo are restored explicitly.
void restoreTerminal() {
  if (!stdin.hasTerminal) return;
  stdin.lineMode = true;
  stdin.echoMode = true;
}

/// Restores the terminal and exits the app.
Never quit() {
  restoreTerminal();
  if (stdout.hasTerminal) console.showCursor();
  print("\nBye!");
  exit(0);
}

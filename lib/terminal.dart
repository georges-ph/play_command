import 'dart:ffi';
import 'dart:io';

import 'package:dart_console/dart_console.dart';
import 'package:ffi/ffi.dart';
import 'package:win32/win32.dart';

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

  _saveNormalMode();
  final key = console.readKey();
  restoreTerminal();
  if (key.controlChar == ControlCharacter.ctrlC) quit();
  return key;
}

/// Switches to raw mode, where key presses arrive one at a time without
/// echo. Call [restoreTerminal] when done.
void enterRawMode() {
  _saveNormalMode();
  console.rawMode = true;
}

/// The Windows console input mode from before raw mode was first used.
int? _normalInputMode;

void _saveNormalMode() {
  if (!Platform.isWindows || _normalInputMode != null) return;
  final handle = GetStdHandle(STD_INPUT_HANDLE).value;
  final mode = calloc<Uint32>();
  try {
    if (GetConsoleMode(handle, mode).value) _normalInputMode = mode.value;
  } finally {
    calloc.free(mode);
  }
}

/// Leaves raw mode and puts the terminal back exactly as it was.
///
/// On Windows, dart_console's `rawMode = false` clears every console input
/// flag (line input, echo, Ctrl+C), which leaves the terminal unusable, so
/// the saved mode is restored instead.
void restoreTerminal() {
  if (!stdin.hasTerminal) return;
  if (console.rawMode) console.rawMode = false;
  final mode = _normalInputMode;
  if (Platform.isWindows && mode != null) {
    SetConsoleMode(GetStdHandle(STD_INPUT_HANDLE).value, CONSOLE_MODE(mode));
  }
}

/// Restores the terminal and exits the app.
Never quit() {
  restoreTerminal();
  if (stdout.hasTerminal) console.showCursor();
  print("\nBye!");
  exit(0);
}

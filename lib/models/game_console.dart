import 'package:dart_console/dart_console.dart';

/// A class that extends [dart_console] `Console` class to create a singleton
class GameConsole extends Console {
  static final GameConsole instance = GameConsole._internal();
  GameConsole._internal();
}

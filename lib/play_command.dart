import 'games/game.dart';
import 'games/games.dart';
import 'terminal.dart';

/// What to do after a game ends, keyed by the letter the player presses.
enum _AfterGame {
  playAgain("n", "Play again"),
  gamesList("l", "Return to games list"),
  exit("x", "Exit");

  final String key;
  final String label;

  const _AfterGame(this.key, this.label);
}

Future<void> run() async {
  Game? game;

  while (true) {
    game ??= _chooseGame();

    await game.play();

    switch (_afterGame()) {
      case _AfterGame.playAgain:
        break;
      case _AfterGame.gamesList:
        game = null;
      case _AfterGame.exit:
        quit();
    }
  }
}

Game _chooseGame() {
  print("\n-------------------- GAMES LIST --------------------\n");
  for (final (i, game) in allGames.indexed) {
    print("${(i + 1).toString().padLeft(2)}. ${game.name.padRight(24)} ${game.description}");
  }
  print("");
  final number = promptInt("Choose your game: ", min: 1, max: allGames.length);
  return allGames[number - 1];
}

_AfterGame _afterGame() {
  print("\n--------------------");
  for (final action in _AfterGame.values) {
    print("${action.key}: ${action.label}");
  }
  print("--------------------");

  console.hideCursor();
  _AfterGame? action;
  while (action == null) {
    final char = readKey().char.toLowerCase();
    for (final candidate in _AfterGame.values) {
      if (candidate.key == char) action = candidate;
    }
  }
  console.showCursor();
  return action;
}

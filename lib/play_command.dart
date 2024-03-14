import 'enums/actions.dart';
import 'game_manager.dart';
import 'games/game.dart';

void run() {
  Game? game;

  while (true) {
    if (game == null) {
      GameManager.instance.gamesList();
      game = GameManager.instance.chooseGame();
    }

    game.play();

    final action = GameManager.instance.endOfGame();
    if (action == Actions.l) game = null;
    if (action == Actions.x) break;
    if (action == Actions.n) game?.reset();
  }
}

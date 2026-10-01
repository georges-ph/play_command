import 'dart:async';

/// How a game ended, from the player's point of view.
enum GameResult { win, loss, draw, none }

/// What [Game.play] returns: the result and an optional numeric score.
class GameOutcome {
  final GameResult result;
  final int? score;

  const GameOutcome(this.result, {this.score});
}

/// A game that can be chosen from the games list.
///
/// Implementations keep all per-round state local to [play], so the same
/// instance can be played any number of times.
abstract class Game {
  /// Name shown in the games list.
  String get name;

  /// One-line description shown in the games list and stats.
  String get description;

  /// Whether a lower [GameOutcome.score] is better (e.g. fewer guesses).
  bool get lowerScoreIsBetter => false;

  FutureOr<GameOutcome> play();
}

import 'dart:async';

/// A game that can be chosen from the games list.
///
/// Implementations keep all per-round state local to [play], so the same
/// instance can be played any number of times.
abstract class Game {
  /// Name shown in the games list.
  String get name;

  /// One-line description shown in the games list.
  String get description;

  FutureOr<void> play();
}

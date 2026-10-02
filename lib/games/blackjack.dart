import 'dart:math';

import '../terminal.dart';
import 'game.dart';

class PlayingCard {
  static const List<String> ranks = ["A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"];
  static const List<String> suits = ["♠", "♥", "♦", "♣"];
  static const List<String> asciiSuits = ["s", "h", "d", "c"];

  final String rank;
  final int suit;

  const PlayingCard(this.rank, this.suit);

  /// Blackjack value, counting an ace as 11 ([handValue] lowers it to 1 when needed).
  int get value => switch (rank) {
    "A" => 11,
    "J" || "Q" || "K" => 10,
    _ => int.parse(rank),
  };

  @override
  String toString() => "$rank${console.supportsEmoji ? suits[suit] : asciiSuits[suit]}";
}

/// The best Blackjack total for [cards], counting aces as 1 or 11.
int handValue(Iterable<PlayingCard> cards) {
  var total = cards.fold(0, (sum, card) => sum + card.value);
  var aces = cards.where((card) => card.rank == "A").length;
  while (total > 21 && aces > 0) {
    total -= 10;
    aces--;
  }
  return total;
}

class Blackjack extends Game {
  final Random _random;

  Blackjack([Random? random]) : _random = random ?? Random();

  @override
  String get name => "Blackjack";

  @override
  String get description => "Get closer to 21 than the dealer";

  @override
  void play() {
    header(name);

    final deck = [
      for (final rank in PlayingCard.ranks)
        for (var suit = 0; suit < 4; suit++) PlayingCard(rank, suit),
    ]..shuffle(_random);

    final player = [deck.removeLast(), deck.removeLast()];
    final dealer = [deck.removeLast(), deck.removeLast()];

    print("Dealer: ${dealer.first} ??");
    _show("You", player);

    if (handValue(player) == 21) {
      _show("\nDealer", dealer);
      if (handValue(dealer) == 21) {
        print("Both have Blackjack. Push!");
        return;
      }
      print(colored("BLACKJACK! You win!", ConsoleColor.green));
      return;
    }

    // Player's turn
    while (handValue(player) < 21) {
      final choice = promptChoice("\n(h)it or (s)tand? ", ["h", "s", "hit", "stand"]);
      if (choice.startsWith("s")) break;
      player.add(deck.removeLast());
      _show("You", player);
    }

    if (handValue(player) > 21) {
      print(colored("\nBust! You lose.", ConsoleColor.red));
      return;
    }

    // Dealer's turn: hits until 17 or more
    print("");
    _show("Dealer", dealer);
    while (handValue(dealer) < 17) {
      dealer.add(deck.removeLast());
      _show("Dealer", dealer);
    }

    final you = handValue(player), them = handValue(dealer);
    if (them > 21 || you > them) {
      print(colored("\nYou win with $you!", ConsoleColor.green));
      return;
    }
    if (you == them) {
      print("\nPush: both have $you.");
      return;
    }
    print(colored("\nThe dealer wins with $them.", ConsoleColor.red));
  }

  void _show(String who, List<PlayingCard> cards) => print("$who: ${cards.join(" ")}  (${handValue(cards)})");
}

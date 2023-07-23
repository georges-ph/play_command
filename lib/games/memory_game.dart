import 'dart:math';

class MemoryGame {
  final List<int> _sequence = [];
  final int _sequenceLength = 5;

  /// Generates a sequence of numbers from 1 to 9
  List<int> generateSequence() {
    for (var i = 0; i < _sequenceLength; i++) {
      int randomNumber = Random().nextInt(9) + 1;
      _sequence.add(randomNumber);
    }
    return _sequence;
  }
}

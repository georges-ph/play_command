import 'package:play_command/games/rock_paper_scissors.dart';
import 'package:test/test.dart';

void main() {
  test("each weapon beats exactly one other", () {
    expect(Weapon.rock.beats(Weapon.scissors), isTrue);
    expect(Weapon.paper.beats(Weapon.rock), isTrue);
    expect(Weapon.scissors.beats(Weapon.paper), isTrue);
    for (final weapon in Weapon.values) {
      expect(weapon.beats(weapon), isFalse);
    }
  });

  test("parses letters and names case-insensitively", () {
    expect(Weapon.parse("r"), Weapon.rock);
    expect(Weapon.parse(" Paper "), Weapon.paper);
    expect(Weapon.parse("S"), Weapon.scissors);
    expect(Weapon.parse("x"), isNull);
    expect(Weapon.parse(""), isNull);
  });
}

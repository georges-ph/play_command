# Play Command

[![CI](https://github.com/georges-ph/play_command/actions/workflows/ci.yml/badge.svg)](https://github.com/georges-ph/play_command/actions/workflows/ci.yml)
[![Release](https://img.shields.io/github/v/release/georges-ph/play_command)](https://github.com/georges-ph/play_command/releases)
[![License: MIT](https://img.shields.io/github/license/georges-ph/play_command)](LICENSE)

A console application that lets you play different games in the command line interface (CLI), written in Dart.

**Website:** https://georges-ph.github.io/play_command/

```
-------------------- GAMES LIST --------------------

 1. Guess the Number         Find the secret number with higher/lower hints
 2. Rock, Paper, Scissors    Best of 3 against the computer
 3. Memory Game              Remember ever-longer number sequences
 4. Tic Tac Toe              Three in a row, against the computer or a friend
 5. Hangman                  Guess the word one letter at a time
 6. Word Scramble            Unscramble 5 words, 3 tries each
 7. Blackjack                Get closer to 21 than the dealer
 8. Pig (Dice)               Dice race to 50, but a 1 loses your turn
 9. Snake                    Eat, grow, and don't bite your tail
10. Minesweeper              Clear the field without hitting a mine

 x. Exit

Choose your game: _
```

## Games

- **Guess the Number:** The computer picks a number from 0 to 1000 and tells you if your guess is *higher* or *lower*.
- **Rock Paper Scissors:** Pick rock, paper, or scissors against the computer. First to win 2 rounds wins the match.
- **Memory Game:** Memorize a sequence of numbers, then type it back. Each correct answer adds one more number. How far can you go?
- **Tic Tac Toe:** Get three of your symbols in a row, against the computer or a friend on the same keyboard.
- **Hangman:** Guess the hidden word one letter at a time before the gallows is complete.
- **Word Scramble:** Unscramble 5 words with 3 tries each. Type `?` for a hint.
- **Blackjack:** Hit or stand to get closer to 21 than the dealer without going bust.
- **Pig (Dice):** Roll as often as you dare and bank your points, but a 1 wipes out your turn. First to 50 wins.
- **Snake:** The classic. Steer with the arrow keys or WASD, eat apples, and don't hit the walls or yourself.
- **Minesweeper:** Move with the arrow keys or WASD, reveal with Space or Enter, and flag mines with F.

## Download

Download `play_command.exe` from the [latest release](https://github.com/georges-ph/play_command/releases/latest) and double-click it. If SmartScreen warns about an unrecognized app, choose *More info* > *Run anyway*.

Windows only for now.

After each game, press `n` to play again, `l` to return to the games list, or `x` to exit.

To build from source instead, see [CONTRIBUTING.md](CONTRIBUTING.md).

## Status

Actively maintained. Ideas for new games are welcome. See [CONTRIBUTING.md](CONTRIBUTING.md).

## License

[MIT](LICENSE)

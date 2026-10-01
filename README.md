# Play Command

[![CI](https://github.com/georges-ph/play_command/actions/workflows/ci.yml/badge.svg)](https://github.com/georges-ph/play_command/actions/workflows/ci.yml)
[![Release](https://img.shields.io/github/v/release/georges-ph/play_command)](https://github.com/georges-ph/play_command/releases)
[![License: MIT](https://img.shields.io/github/license/georges-ph/play_command)](LICENSE)

A console application that lets you play different games in the command line interface (CLI), written in Dart.

```
-------------------- GAMES LIST --------------------

1. Guess the number
2. Rock, Paper, Scissors
3. Memory Game
4. Tic Tac Toe
Choose your game: _
```

## Games

- **Guess the Number:** The computer chooses a random number and you have to guess it. The computer will tell you if your guess is *higher* or *lower*.
- **Rock Paper Scissors:** Choose one of the objects (rock, paper, or scissors). The computer picks its own at random and the winner is decided over 3 rounds.
- **Tic Tac Toe:** The classic game for two players on the same keyboard. Get three of your symbols (*X* or *O*) in a row to win!
- **Memory Game:** You'll be shown a sequence of numbers to memorize for a few seconds. Then try to recall the sequence by typing it out. Can you remember them all?

## Getting started

Requires the [Dart SDK](https://dart.dev/get-dart) 3.3 or newer.

```sh
git clone https://github.com/georges-ph/play_command.git
cd play_command
dart pub get
dart run
```

To build a standalone executable:

```sh
dart compile exe bin/play_command.dart -o play_command
```

After each game, press `n` to play again, `l` to return to the games list, or `x` to exit.

## Status

Actively maintained. Ideas for new games are welcome. See [CONTRIBUTING.md](CONTRIBUTING.md).

## License

[MIT](LICENSE)

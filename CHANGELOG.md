# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.2.0] - 2026-10-02

### Added

- Hangman: guess the word one letter at a time.
- Word Scramble: unscramble 5 words with 3 tries each.
- Blackjack: beat the dealer without going over 21.
- Pig (Dice): dice race to 50 against the computer.
- Snake: real-time snake controlled with the arrow keys or WASD.
- Minesweeper: cursor-controlled minefield with flags and a safe first move.
- Colored output on terminals that support it.
- Ready-to-run Windows executable attached to each release.

### Changed

- Requires Dart 3.11; dependencies updated to their latest versions.
- Tic Tac Toe can now be played against the computer (or by two players).
- Memory Game now gets one number longer after each correct answer.
- Rock Paper Scissors is now a best-of-3 match.
- The games list shows a short description of each game.

### Fixed

- Tic Tac Toe printed "Invalid move" after the winning move.
- Rock Paper Scissors picked a random weapon for invalid or uppercase input instead of asking again.
- Guess the Number counted out-of-range guesses.

## [1.1.0] - 2024-03-14

### Added

- Memory Game: memorize a sequence of numbers and type it back.
- Tic Tac Toe: two players on the same keyboard.

### Changed

- Restructured and refactored project files and code with some optimizations.

## [1.0.0] - 2023-07-18

### Added

- Initial version with Guess the Number and Rock Paper Scissors.

[1.2.0]: https://github.com/georges-ph/play_command/compare/v1.1.0...v1.2.0
[1.1.0]: https://github.com/georges-ph/play_command/compare/v1.0.0...v1.1.0
[1.0.0]: https://github.com/georges-ph/play_command/releases/tag/v1.0.0

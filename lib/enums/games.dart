// ignore_for_file: constant_identifier_names

enum Games {
  guess_the_number("Guess the number"),
  rock_paper_scissors("Rock, Paper, Scissors"),
  memory_game("Memory Game");

  final String gameName;

  const Games(this.gameName);
}

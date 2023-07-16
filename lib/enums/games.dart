// ignore_for_file: constant_identifier_names

enum Games {
  guess_the_number(name: "Guess the number"),
  rock_paper_scissors(name: "Rock, Paper, Scissors");

  final String name;

  const Games({
    required this.name,
  });
}

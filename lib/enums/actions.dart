enum Actions {
  none(""),
  l("Return to games list"),
  n("Play again"),
  x("Exit");

  final String actionName;

  const Actions(this.actionName);
}

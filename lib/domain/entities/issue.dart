class Issue {
  final int id;
  final String title;
  final int number;
  final String user;
  final String state;
  final bool isPR;

  Issue({
    required this.id,
    required this.title,
    required this.number,
    required this.user,
    required this.state,
    required this.isPR,
  });
}

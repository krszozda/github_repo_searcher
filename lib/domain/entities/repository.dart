class Repository {
  final int id;
  final String name;
  final String fullName;
  final String owner;
  final String description;
  final int stars;
  final int forks;
  final int openIssues;
  final String avatarUrl;

  Repository({
    required this.id,
    required this.name,
    required this.fullName,
    required this.owner,
    required this.description,
    required this.stars,
    required this.forks,
    required this.openIssues,
    required this.avatarUrl,
  });
}

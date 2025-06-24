import '../../domain/entities/repository.dart';

class RepositoryModel extends Repository {
  RepositoryModel({
    required super.id,
    required super.name,
    required super.fullName,
    required super.owner,
    required super.description,
    required super.stars,
    required super.forks,
    required super.openIssues,
    required super.avatarUrl,
  });

  factory RepositoryModel.fromJson(Map<String, dynamic> json) {
    return RepositoryModel(
      id: json['id'],
      name: json['name'],
      fullName: json['full_name'],
      owner: json['owner']['login'],
      description: json['description'] ?? '',
      stars: json['stargazers_count'],
      forks: json['forks_count'],
      openIssues: json['open_issues_count'],
      avatarUrl: json['owner']['avatar_url'],
    );
  }

  Repository toEntity() => Repository(
        id: id,
        name: name,
        fullName: fullName,
        owner: owner,
        description: description,
        stars: stars,
        forks: forks,
        openIssues: openIssues,
        avatarUrl: avatarUrl,
      );
}

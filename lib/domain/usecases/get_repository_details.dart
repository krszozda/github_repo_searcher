import '../entities/repository.dart';
import '../repositories/github_repository.dart';

class GetRepositoryDetails {
  final GitHubRepository repository;
  GetRepositoryDetails(this.repository);

  Future<Repository> call(String owner, String repo) async {
    return await repository.getRepositoryDetails(owner, repo);
  }
}

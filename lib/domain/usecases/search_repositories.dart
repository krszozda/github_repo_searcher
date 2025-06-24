import '../entities/repository.dart';
import '../repositories/github_repository.dart';

class SearchRepositories {
  final GitHubRepository repository;
  SearchRepositories(this.repository);

  Future<List<Repository>> call(String query, {int page = 1}) async {
    return await repository.searchRepositories(query, page: page);
  }
}

import '../entities/repository.dart';
import '../entities/issue.dart';

abstract class GitHubRepository {
  Future<List<Repository>> searchRepositories(String query, {int page = 1});
  Future<List<Repository>> getTrendingRepositories({int page = 1});
  Future<Repository> getRepositoryDetails(String owner, String repo);
  Future<List<Issue>> getIssuesOrPRs(String owner, String repo, {bool isPR = false});
}

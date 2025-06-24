import '../../domain/entities/repository.dart';
import '../../domain/entities/issue.dart';
import '../../domain/repositories/github_repository.dart';
import '../datasources/github_remote_data_source.dart';

class GitHubRepositoryImpl implements GitHubRepository {
  final GitHubRemoteDataSource remoteDataSource;

  GitHubRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Repository>> searchRepositories(String query, {int page = 1}) async {
    final models = await remoteDataSource.searchRepositories(query, page: page);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<Repository>> getTrendingRepositories({int page = 1}) async {
    final models = await remoteDataSource.getTrendingRepositories(page: page);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<Repository> getRepositoryDetails(String owner, String repo) async {
    final model = await remoteDataSource.getRepositoryDetails(owner, repo);
    return model.toEntity();
  }

  @override
  Future<List<Issue>> getIssuesOrPRs(String owner, String repo, {bool isPR = false}) async {
    final models = await remoteDataSource.getIssuesOrPRs(owner, repo, isPR: isPR);
    return models.map((m) => m.toEntity()).toList();
  }
}

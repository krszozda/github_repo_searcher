import '../entities/repository.dart';
import '../repositories/github_repository.dart';

class GetTrendingRepositories {
  final GitHubRepository repository;
  GetTrendingRepositories(this.repository);

  Future<List<Repository>> call({int page = 1}) async {
    return await repository.getTrendingRepositories(page: page);
  }
} 
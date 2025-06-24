import 'package:flutter_test/flutter_test.dart';
import 'package:github_repo_searcher/data/repositories/github_repository_impl.dart';
import 'package:github_repo_searcher/data/datasources/github_remote_data_source.dart';
import 'package:github_repo_searcher/data/models/repository_model.dart';
import 'package:github_repo_searcher/data/models/issue_model.dart';
import 'package:github_repo_searcher/domain/entities/repository.dart';
import 'package:github_repo_searcher/domain/entities/issue.dart';

class MockGitHubRemoteDataSource implements GitHubRemoteDataSource {
  @override
  Future<List<RepositoryModel>> searchRepositories(String query, {int page = 1}) async => [RepositoryModel(id: 1, name: 'repo', fullName: 'owner/repo', owner: 'owner', description: 'desc', stars: 10, forks: 2, openIssues: 1, avatarUrl: 'https://example.com/avatar.jpg')];

  @override
  Future<List<RepositoryModel>> getTrendingRepositories({int page = 1}) async => [RepositoryModel(id: 1, name: 'trending', fullName: 'owner/trending', owner: 'owner', description: 'trending repo', stars: 100, forks: 20, openIssues: 5, avatarUrl: 'https://example.com/avatar.jpg')];

  @override
  Future<RepositoryModel> getRepositoryDetails(String owner, String repo) async => RepositoryModel(id: 1, name: 'repo', fullName: 'owner/repo', owner: 'owner', description: 'desc', stars: 10, forks: 2, openIssues: 1, avatarUrl: 'https://example.com/avatar.jpg');

  @override
  Future<List<IssueModel>> getIssuesOrPRs(String owner, String repo, {bool isPR = false}) async => [IssueModel(id: 1, title: 'issue', number: 1, user: 'user', state: 'open', isPR: isPR)];
}

void main() {
  test('searchRepositories returns list of Repository', () async {
    final repo = GitHubRepositoryImpl(remoteDataSource: MockGitHubRemoteDataSource());
    final result = await repo.searchRepositories('repo');
    expect(result, isA<List<Repository>>());
    expect(result.first.name, 'repo');
  });

  test('getTrendingRepositories returns list of Repository', () async {
    final repo = GitHubRepositoryImpl(remoteDataSource: MockGitHubRemoteDataSource());
    final result = await repo.getTrendingRepositories();
    expect(result, isA<List<Repository>>());
    expect(result.first.name, 'trending');
  });

  test('getRepositoryDetails returns Repository', () async {
    final repo = GitHubRepositoryImpl(remoteDataSource: MockGitHubRemoteDataSource());
    final result = await repo.getRepositoryDetails('owner', 'repo');
    expect(result, isA<Repository>());
    expect(result.name, 'repo');
  });

  test('getIssuesOrPRs returns list of Issue', () async {
    final repo = GitHubRepositoryImpl(remoteDataSource: MockGitHubRemoteDataSource());
    final result = await repo.getIssuesOrPRs('owner', 'repo');
    expect(result, isA<List<Issue>>());
    expect(result.first.title, 'issue');
  });
} 
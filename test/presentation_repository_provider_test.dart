import 'package:flutter_test/flutter_test.dart';
import 'package:github_repo_searcher/presentation/providers/repository_provider.dart';
import 'package:github_repo_searcher/domain/entities/repository.dart';
import 'package:github_repo_searcher/domain/entities/issue.dart';
import 'package:github_repo_searcher/domain/repositories/github_repository.dart';
import 'package:github_repo_searcher/domain/usecases/search_repositories.dart';
import 'package:github_repo_searcher/domain/usecases/get_repository_details.dart';
import 'package:github_repo_searcher/domain/usecases/get_issues_or_prs.dart';
import 'package:github_repo_searcher/domain/usecases/get_trending_repositories.dart';

class MockGitHubRepository implements GitHubRepository {
  @override
  Future<List<Repository>> searchRepositories(String query, {int page = 1}) async => [Repository(id: 1, name: 'repo', fullName: 'owner/repo', owner: 'owner', description: 'desc', stars: 10, forks: 2, openIssues: 1, avatarUrl: 'https://example.com/avatar.jpg')];

  @override
  Future<List<Repository>> getTrendingRepositories({int page = 1}) async => [Repository(id: 1, name: 'trending', fullName: 'owner/trending', owner: 'owner', description: 'trending repo', stars: 100, forks: 20, openIssues: 5, avatarUrl: 'https://example.com/avatar.jpg')];

  @override
  Future<Repository> getRepositoryDetails(String owner, String repo) async => Repository(id: 1, name: 'repo', fullName: 'owner/repo', owner: 'owner', description: 'desc', stars: 10, forks: 2, openIssues: 1, avatarUrl: 'https://example.com/avatar.jpg');

  @override
  Future<List<Issue>> getIssuesOrPRs(String owner, String repo, {bool isPR = false}) async => [Issue(id: 1, title: 'issue', number: 1, user: 'user', state: 'open', isPR: isPR)];
}

void main() {
  final mockRepo = MockGitHubRepository();
  test('RepositoryProvider loadTrendingRepositories updates repositories', () async {
    final provider = RepositoryProvider(
      searchRepositories: SearchRepositories(mockRepo),
      getRepositoryDetails: GetRepositoryDetails(mockRepo),
      getIssuesOrPRs: GetIssuesOrPRs(mockRepo),
      getTrendingRepositories: GetTrendingRepositories(mockRepo),
    );
    await provider.loadTrendingRepositories();
    expect(provider.repositories.isNotEmpty, true);
    expect(provider.repositories.first.name, 'trending');
  });

  test('RepositoryProvider search updates repositories', () async {
    final provider = RepositoryProvider(
      searchRepositories: SearchRepositories(mockRepo),
      getRepositoryDetails: GetRepositoryDetails(mockRepo),
      getIssuesOrPRs: GetIssuesOrPRs(mockRepo),
      getTrendingRepositories: GetTrendingRepositories(mockRepo),
    );
    await provider.search('repo');
    expect(provider.repositories.isNotEmpty, true);
    expect(provider.repositories.first.name, 'repo');
  });

  test('RepositoryProvider fetchRepositoryDetails updates selectedRepository', () async {
    final provider = RepositoryProvider(
      searchRepositories: SearchRepositories(mockRepo),
      getRepositoryDetails: GetRepositoryDetails(mockRepo),
      getIssuesOrPRs: GetIssuesOrPRs(mockRepo),
      getTrendingRepositories: GetTrendingRepositories(mockRepo),
    );
    await provider.fetchRepositoryDetails('owner', 'repo');
    expect(provider.selectedRepository, isNotNull);
    expect(provider.selectedRepository!.name, 'repo');
  });

  test('RepositoryProvider fetchIssuesOrPRs updates issuesOrPRs', () async {
    final provider = RepositoryProvider(
      searchRepositories: SearchRepositories(mockRepo),
      getRepositoryDetails: GetRepositoryDetails(mockRepo),
      getIssuesOrPRs: GetIssuesOrPRs(mockRepo),
      getTrendingRepositories: GetTrendingRepositories(mockRepo),
    );
    await provider.fetchIssuesOrPRs('owner', 'repo');
    expect(provider.issuesOrPRs.isNotEmpty, true);
    expect(provider.issuesOrPRs.first.title, 'issue');
  });
} 
import 'package:flutter/material.dart';
import '../../domain/entities/repository.dart';
import '../../domain/entities/issue.dart';
import '../../domain/usecases/search_repositories.dart';
import '../../domain/usecases/get_repository_details.dart';
import '../../domain/usecases/get_issues_or_prs.dart';
import '../../domain/usecases/get_trending_repositories.dart';

class RepositoryProvider extends ChangeNotifier {
  final SearchRepositories searchRepositories;
  final GetRepositoryDetails getRepositoryDetails;
  final GetIssuesOrPRs getIssuesOrPRs;
  final GetTrendingRepositories getTrendingRepositories;

  RepositoryProvider({
    required this.searchRepositories,
    required this.getRepositoryDetails,
    required this.getIssuesOrPRs,
    required this.getTrendingRepositories,
  });

  List<Repository> repositories = [];
  Repository? selectedRepository;
  List<Issue> issuesOrPRs = [];
  bool isLoading = false;
  bool isLoadingMore = false;
  String? error;
  int currentPage = 1;
  String currentQuery = '';
  bool hasMoreData = true;

  Future<void> loadTrendingRepositories() async {
    isLoading = true;
    error = null;
    currentPage = 1;
    currentQuery = '';
    hasMoreData = true;
    notifyListeners();
    try {
      repositories = await getTrendingRepositories(page: currentPage);
    } catch (e) {
      error = e.toString();
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> search(String query, {bool isNewSearch = true}) async {
    if (isNewSearch) {
      isLoading = true;
      currentPage = 1;
      currentQuery = query;
      hasMoreData = true;
    } else {
      isLoadingMore = true;
    }
    error = null;
    notifyListeners();
    try {
      final newRepositories = await searchRepositories(query, page: currentPage);
      if (isNewSearch) {
        repositories = newRepositories;
      } else {
        repositories.addAll(newRepositories);
      }
      hasMoreData = newRepositories.length == 10;
    } catch (e) {
      error = e.toString();
    }
    isLoading = false;
    isLoadingMore = false;
    notifyListeners();
  }

  Future<void> loadMoreRepositories() async {
    if (!hasMoreData || isLoadingMore) return;
    currentPage++;
    await search(currentQuery, isNewSearch: false);
  }

  Future<void> fetchRepositoryDetails(String owner, String repo) async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      selectedRepository = await getRepositoryDetails(owner, repo);
    } catch (e) {
      error = e.toString();
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> fetchIssuesOrPRs(String owner, String repo, {bool isPR = false}) async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      issuesOrPRs = await getIssuesOrPRs(owner, repo, isPR: isPR);
    } catch (e) {
      error = e.toString();
    }
    isLoading = false;
    notifyListeners();
  }
}

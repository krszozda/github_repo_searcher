import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/repository_model.dart';
import '../models/issue_model.dart';

abstract class GitHubRemoteDataSource {
  Future<List<RepositoryModel>> searchRepositories(String query, {int page = 1});
  Future<List<RepositoryModel>> getTrendingRepositories({int page = 1});
  Future<RepositoryModel> getRepositoryDetails(String owner, String repo);
  Future<List<IssueModel>> getIssuesOrPRs(String owner, String repo, {bool isPR = false});
}

class GitHubRemoteDataSourceImpl implements GitHubRemoteDataSource {
  static const baseUrl = 'https://api.github.com';

  @override
  Future<List<RepositoryModel>> searchRepositories(String query, {int page = 1}) async {
    final response = await http.get(Uri.parse('$baseUrl/search/repositories?q=$query&per_page=10&page=$page'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['items'] as List)
          .map((item) => RepositoryModel.fromJson(item))
          .toList();
    } else {
      throw Exception('Failed to search repositories');
    }
  }

  @override
  Future<List<RepositoryModel>> getTrendingRepositories({int page = 1}) async {
    final response = await http.get(Uri.parse('$baseUrl/search/repositories?q=stars:>1&sort=stars&order=desc&per_page=10&page=$page'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['items'] as List)
          .map((item) => RepositoryModel.fromJson(item))
          .toList();
    } else {
      throw Exception('Failed to get trending repositories');
    }
  }

  @override
  Future<RepositoryModel> getRepositoryDetails(String owner, String repo) async {
    final response = await http.get(Uri.parse('$baseUrl/repos/$owner/$repo'));
    if (response.statusCode == 200) {
      return RepositoryModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to get repository details');
    }
  }

  @override
  Future<List<IssueModel>> getIssuesOrPRs(String owner, String repo, {bool isPR = false}) async {
    final type = isPR ? 'pulls' : 'issues';
    final response = await http.get(Uri.parse('$baseUrl/repos/$owner/$repo/$type?state=open'));
    if (response.statusCode == 200) {
      return (json.decode(response.body) as List)
          .map((item) => IssueModel.fromJson(item))
          .toList();
    } else {
      throw Exception('Failed to get $type');
    }
  }
}

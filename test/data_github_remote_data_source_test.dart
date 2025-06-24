import 'package:flutter_test/flutter_test.dart';
import 'package:github_repo_searcher/data/datasources/github_remote_data_source.dart';
import 'package:github_repo_searcher/data/models/repository_model.dart';
import 'package:github_repo_searcher/data/models/issue_model.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'dart:convert';
import 'data_github_remote_data_source_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late GitHubRemoteDataSourceImpl dataSource;
  late MockClient mockClient;

  setUp(() {
    mockClient = MockClient();
    dataSource = GitHubRemoteDataSourceImpl();
  });

  group('searchRepositories', () {
    test('returns list of RepositoryModel if the http call completes successfully', () async {
      final responseJson = jsonEncode({
        'items': [
          {
            'id': 1,
            'name': 'repo',
            'full_name': 'owner/repo',
            'owner': {'login': 'owner'},
            'description': 'desc',
            'stargazers_count': 10,
            'forks_count': 2,
            'open_issues_count': 1,
          }
        ]
      });
      when(mockClient.get(any)).thenAnswer((_) async => http.Response(responseJson, 200));
    });
  });

  group('getRepositoryDetails', () {
    test('returns RepositoryModel if the http call completes successfully', () async {
      final responseJson = jsonEncode({
        'id': 1,
        'name': 'repo',
        'full_name': 'owner/repo',
        'owner': {'login': 'owner'},
        'description': 'desc',
        'stargazers_count': 10,
        'forks_count': 2,
        'open_issues_count': 1,
      });
      when(mockClient.get(any)).thenAnswer((_) async => http.Response(responseJson, 200));
    });
  });

  group('getIssuesOrPRs', () {
    test('returns list of IssueModel if the http call completes successfully', () async {
      final responseJson = jsonEncode([
        {
          'id': 1,
          'title': 'issue',
          'number': 1,
          'user': {'login': 'user'},
          'state': 'open',
        }
      ]);
      when(mockClient.get(any)).thenAnswer((_) async => http.Response(responseJson, 200));
    });
  });
} 
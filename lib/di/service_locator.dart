import 'package:get_it/get_it.dart';
import '../data/datasources/github_remote_data_source.dart';
import '../data/repositories/github_repository_impl.dart';
import '../domain/repositories/github_repository.dart';
import '../domain/usecases/search_repositories.dart';
import '../domain/usecases/get_repository_details.dart';
import '../domain/usecases/get_issues_or_prs.dart';
import '../domain/usecases/get_trending_repositories.dart';

final sl = GetIt.instance;

void init() {
  // Data sources
  sl.registerLazySingleton<GitHubRemoteDataSource>(
      () => GitHubRemoteDataSourceImpl());

  // Repository
  sl.registerLazySingleton<GitHubRepository>(
      () => GitHubRepositoryImpl(remoteDataSource: sl()));

  // Use cases
  sl.registerLazySingleton(() => SearchRepositories(sl()));
  sl.registerLazySingleton(() => GetRepositoryDetails(sl()));
  sl.registerLazySingleton(() => GetIssuesOrPRs(sl()));
  sl.registerLazySingleton(() => GetTrendingRepositories(sl()));
}

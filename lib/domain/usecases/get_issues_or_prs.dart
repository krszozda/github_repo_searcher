import '../entities/issue.dart';
import '../repositories/github_repository.dart';

class GetIssuesOrPRs {
  final GitHubRepository repository;
  GetIssuesOrPRs(this.repository);

  Future<List<Issue>> call(String owner, String repo, {bool isPR = false}) async {
    return await repository.getIssuesOrPRs(owner, repo, isPR: isPR);
  }
}

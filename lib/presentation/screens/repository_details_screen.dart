import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/repository_provider.dart';
import 'issues_prs_screen.dart';

class RepositoryDetailsScreen extends StatefulWidget {
  final String owner;
  final String repo;
  const RepositoryDetailsScreen({Key? key, required this.owner, required this.repo}) : super(key: key);

  @override
  State<RepositoryDetailsScreen> createState() => _RepositoryDetailsScreenState();
}

class _RepositoryDetailsScreenState extends State<RepositoryDetailsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<RepositoryProvider>(context, listen: false)
          .fetchRepositoryDetails(widget.owner, widget.repo);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RepositoryProvider>(context);
    final repo = provider.selectedRepository;
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(
        backgroundColor: const Color(0xFF161B22),
        title: const Text(
          'Repository Details',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        elevation: 0,
      ),
      body: provider.isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF58A6FF)),
              ),
            )
          : provider.error != null
              ? Center(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF21262D),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: const Color(0xFFF85149)),
                    ),
                    child: Text(
                      provider.error!,
                      style: const TextStyle(color: Color(0xFFF85149)),
                    ),
                  ),
                )
              : repo == null
                  ? const Center(
                      child: Text(
                        'No data',
                        style: TextStyle(color: Color(0xFF7D8590)),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 24,
                                backgroundImage: NetworkImage(repo.avatarUrl),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      repo.fullName,
                                      style: const TextStyle(
                                        color: Color(0xFF58A6FF),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 20,
                                      ),
                                    ),
                                    Text(
                                      'by ${repo.owner}',
                                      style: const TextStyle(
                                        color: Color(0xFF7D8590),
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          if (repo.description.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFF161B22),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: const Color(0xFF30363D)),
                              ),
                              child: Text(
                                repo.description,
                                style: const TextStyle(
                                  color: Color(0xFF7D8590),
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFF161B22),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: const Color(0xFF30363D)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildStatItem(Icons.star, 'Stars', repo.stars.toString(), Colors.amber),
                                _buildStatItem(Icons.call_split, 'Forks', repo.forks.toString(), const Color(0xFF7D8590)),
                                _buildStatItem(Icons.error_outline, 'Issues', repo.openIssues.toString(), const Color(0xFF7D8590)),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => IssuesPRsScreen(
                                          owner: repo.owner,
                                          repo: repo.name,
                                          isPR: false,
                                        ),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.error_outline),
                                  label: const Text('View Issues'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF21262D),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => IssuesPRsScreen(
                                          owner: repo.owner,
                                          repo: repo.name,
                                          isPR: true,
                                        ),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.merge_type),
                                  label: const Text('View PRs'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF21262D),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
    );
  }

  Widget _buildStatItem(IconData icon, String label, String value, Color color) {
    return Column(
      children: [
        Icon(icon, size: 24, color: color),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF7D8590),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

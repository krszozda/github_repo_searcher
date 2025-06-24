import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/repository_provider.dart';

class IssuesPRsScreen extends StatefulWidget {
  final String owner;
  final String repo;
  final bool isPR;
  const IssuesPRsScreen({Key? key, required this.owner, required this.repo, required this.isPR}) : super(key: key);

  @override
  State<IssuesPRsScreen> createState() => _IssuesPRsScreenState();
}

class _IssuesPRsScreenState extends State<IssuesPRsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<RepositoryProvider>(context, listen: false)
          .fetchIssuesOrPRs(widget.owner, widget.repo, isPR: widget.isPR);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RepositoryProvider>(context);
    final title = widget.isPR ? 'Pull Requests' : 'Issues';
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(
        backgroundColor: const Color(0xFF161B22),
        title: Text(
          title,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
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
              : provider.issuesOrPRs.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            widget.isPR ? Icons.merge_type : Icons.error_outline,
                            size: 64,
                            color: const Color(0xFF7D8590),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No open $title',
                            style: const TextStyle(
                              color: Color(0xFF7D8590),
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: provider.issuesOrPRs.length,
                      itemBuilder: (context, index) {
                        final item = provider.issuesOrPRs[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF161B22),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: const Color(0xFF30363D)),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: item.isPR ? const Color(0xFF58A6FF) : const Color(0xFF238636),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Icon(
                                item.isPR ? Icons.merge_type : Icons.error_outline,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            title: Text(
                              item.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                'By ${item.user} • #${item.number} • ${item.state}',
                                style: const TextStyle(
                                  color: Color(0xFF7D8590),
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}

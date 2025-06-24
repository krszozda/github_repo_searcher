import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/repository_provider.dart';
import 'repository_details_screen.dart';
import 'dart:async';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<RepositoryProvider>(context, listen: false).loadTrendingRepositories();
    });
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      final provider = Provider.of<RepositoryProvider>(context, listen: false);
      provider.loadMoreRepositories();
    }
  }

  void _onSearchChanged(String value) {
    _debounceTimer?.cancel();
    if (value.length >= 3) {
      _debounceTimer = Timer(const Duration(milliseconds: 500), () {
        final provider = Provider.of<RepositoryProvider>(context, listen: false);
        provider.search(value);
      });
    } else if (value.isEmpty) {
      final provider = Provider.of<RepositoryProvider>(context, listen: false);
      provider.loadTrendingRepositories();
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RepositoryProvider>(context);
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(
        backgroundColor: const Color(0xFF161B22),
        title: const Text(
          'GitHub Repo Searcher',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF0D1117),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: const Color(0xFF30363D)),
              ),
              child: TextField(
                controller: _controller,
                onChanged: _onSearchChanged,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Search repositories...',
                  hintStyle: TextStyle(color: Color(0xFF7D8590)),
                  prefixIcon: Icon(Icons.search, color: Color(0xFF7D8590)),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (provider.isLoading && provider.repositories.isEmpty)
              const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF58A6FF)),
                ),
              ),
            if (provider.error != null)
              Container(
                padding: const EdgeInsets.all(12),
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
            if (!provider.isLoading && provider.error == null)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (provider.currentQuery.isEmpty && provider.repositories.isNotEmpty)
                      const Padding(
                        padding: EdgeInsets.only(bottom: 16),
                        child: Text(
                          '🔥 Trending Repositories',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: provider.repositories.length + (provider.hasMoreData ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == provider.repositories.length) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(16),
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF58A6FF)),
                                ),
                              ),
                            );
                          }
                          final repo = provider.repositories[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF161B22),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: const Color(0xFF30363D)),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(16),
                              leading: CircleAvatar(
                                radius: 20,
                                backgroundImage: NetworkImage(repo.avatarUrl),
                              ),
                              title: Text(
                                repo.fullName,
                                style: const TextStyle(
                                  color: Color(0xFF58A6FF),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (repo.description.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Text(
                                        repo.description,
                                        style: const TextStyle(
                                          color: Color(0xFF7D8590),
                                          fontSize: 14,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      _buildStatItem(Icons.star, repo.stars.toString(), Colors.amber),
                                      const SizedBox(width: 16),
                                      _buildStatItem(Icons.call_split, repo.forks.toString(), const Color(0xFF7D8590)),
                                      const SizedBox(width: 16),
                                      _buildStatItem(Icons.error_outline, repo.openIssues.toString(), const Color(0xFF7D8590)),
                                    ],
                                  ),
                                ],
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => RepositoryDetailsScreen(
                                      owner: repo.owner,
                                      repo: repo.name,
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String text, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            color: const Color(0xFF7D8590),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

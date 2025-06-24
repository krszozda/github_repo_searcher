import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'di/service_locator.dart' as di;
import 'presentation/providers/repository_provider.dart';
import 'presentation/screens/search_screen.dart';

void main() {
  di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => RepositoryProvider(
            searchRepositories: di.sl(),
            getRepositoryDetails: di.sl(),
            getIssuesOrPRs: di.sl(),
            getTrendingRepositories: di.sl(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'GitHub Repo Searcher',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: const SearchScreen(),
      ),
    );
  }
}

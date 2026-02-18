import 'package:flutter/material.dart';
import 'package:gharzo_project/screens/reels/reels_feed/real_search/search_reel_provider.dart';
import 'package:provider/provider.dart';


class SearchReelsScreen extends StatelessWidget {
  const SearchReelsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ReelsSearchProvider(),
      child: Scaffold(
        appBar: AppBar(title: const Text("Search Reels")),
        body: Consumer<ReelsSearchProvider>(
          builder: (context, provider, _) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (provider.reels.isEmpty) {
              return const Center(child: Text("No reels found"));
            }

            return ListView.builder(
              itemCount: provider.reels.length,
              itemBuilder: (context, index) {
                final reel = provider.reels[index];
                return ListTile(
                  leading: Image.network(reel.imageUrl, width: 50, height: 50, fit: BoxFit.cover),
                  title: Text(reel.title),
                  subtitle: Text("${reel.city} | Tags: ${reel.tags.join(', ')}"),
                );
              },
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Provider.of<ReelsSearchProvider>(context, listen: false).searchReels(
              query: 'beautiful',
              city: 'Indore',
              tags: ['luxury', '2bhk'],
              page: 1,
              limit: 10,
            );
          },
          child: const Icon(Icons.search),
        ),
      ),
    );
  }
}

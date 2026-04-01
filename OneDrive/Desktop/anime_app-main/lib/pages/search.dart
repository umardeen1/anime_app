import 'package:anime_app/pages/anime_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/anime_bloc.dart';
// Ensure this matches your file name

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  // Controller ko build ke bahar rakha hai taaki state save rahe
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: TextField(
          controller: _controller,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "Search Anime...",
            hintStyle: const TextStyle(color: Colors.grey),
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear, color: Colors.grey),
              onPressed: () => _controller.clear(),
            ),
          ),
          onSubmitted: (query) {
            if (query.isNotEmpty) {
              // Ensure SearchAnimeEvent is defined in your anime_bloc.dart
              context.read<AnimeBloc>().add(SearchAnimeEvent(query));
            }
          },
        ),
      ),
      body: BlocBuilder<AnimeBloc, AnimeState>(
        builder: (context, state) {
          if (state is AnimeLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.red),
            );
          }

          if (state is AnimeLoaded) {
            // Agar search result khali hai
            if (state.trending.isEmpty) {
              return const Center(
                child: Text(
                  "No anime found",
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                // PDF Requirement: 2-column grid view
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: state.trending.length,
                itemBuilder: (context, index) {
                  final anime = state.trending[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AnimeDetailPage(anime: anime),
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              anime.imageUrl,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              // Error handling for images
                              errorBuilder:
                                  (context, error, stackTrace) => const Icon(
                                    Icons.broken_image,
                                    color: Colors.grey,
                                  ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          anime.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          }

          return const Center(
            child: Text(
              "Type and press enter to search",
              style: TextStyle(color: Colors.grey),
            ),
          );
        },
      ),
    );
  }
}

import 'package:anime_app/models/anime.dart';
import 'package:anime_app/pages/anime_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../bloc/anime_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // Trailer launch function (with fallback for demo)
  Future<void> _launchTrailer(String? url, BuildContext context) async {
    final String finalUrl =
        (url != null && url.isNotEmpty)
            ? url
            : "https://www.youtube.com/watch?v=hB9vAn8Oat8"; // Fallback trailer

    final Uri uri = Uri.parse(finalUrl);
    try {
      bool launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched) {
        await launchUrl(uri, mode: LaunchMode.platformDefault);
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocBuilder<AnimeBloc, AnimeState>(
        builder: (context, state) {
          if (state is AnimeLoading) return _buildShimmer();
          if (state is AnimeLoaded) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  // 1. Dynamic Header with SS style
                  _buildHeader(context, state.randomAnime, state.trending),

                  // 2. Trending Section
                  _buildList("Trending Anime", state.trending, state.trending),

                  // 3. Upcoming Section
                  _buildList("Upcoming Anime", state.upcoming, state.trending),
                ],
              ),
            );
          }
          return const Center(
            child: Text(
              "Error loading data",
              style: TextStyle(color: Colors.white),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, anime, trendingList) {
    return Stack(
      children: [
        // Background Poster
        Image.network(
          anime.imageUrl,
          height: 550,
          fit: BoxFit.cover,
          width: double.infinity,
        ),
        // Dark Gradient for Text Visibility
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                stops: const [0.0, 0.4, 0.9],
                colors: [
                  Colors.black.withOpacity(0.95),
                  Colors.black.withOpacity(0.3),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        // Header Content
        Positioned(
          bottom: 30,
          left: 0,
          right: 0,
          child: Column(
            children: [
              Text(
                anime.title.toUpperCase(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  anime.synopsis ?? "",
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ),
              const SizedBox(height: 25),
              // Play & My List Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _headerButton(
                    label: "Play",
                    icon: Icons.play_arrow,
                    color: Colors.red,
                    onTap: () => _launchTrailer(anime.trailerUrl, context),
                  ),
                  const SizedBox(width: 15),
                  _headerButton(
                    label: "My List",
                    icon: Icons.add,
                    isOutlined: true,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Added to My List")),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _headerButton({
    required String label,
    required IconData icon,
    Color? color,
    bool isOutlined = false,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: 135,
      height: 45,
      child:
          isOutlined
              ? OutlinedButton.icon(
                onPressed: onTap,
                icon: Icon(icon, color: Colors.white),
                label: Text(label),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              )
              : ElevatedButton.icon(
                onPressed: onTap,
                icon: Icon(icon, color: Colors.white),
                label: Text(label),
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
    );
  }

  Widget _buildList(String title, List list, List trendingList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 25, 15, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const Text(
                "View All",
                style: TextStyle(color: Colors.redAccent, fontSize: 14),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: 15),
            itemCount: list.length,
            itemBuilder: (context, i) {
              final anime = list[i];
              return GestureDetector(
                onTap:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => AnimeDetailPage(
                              anime: anime,
                              trendingList: trendingList as List<Anime>,
                            ),
                      ),
                    ),
                child: Container(
                  width: 130,
                  margin: const EdgeInsets.only(right: 12),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          anime.imageUrl,
                          fit: BoxFit.cover,
                          height: 190,
                          width: 130,
                        ),
                      ),
                      // Rating Badge
                      if (anime.score != null)
                        Positioned(
                          top: 8,
                          left: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Colors.white,
                                  size: 12,
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  anime.score.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[900]!,
      highlightColor: Colors.grey[800]!,
      child: Column(
        children: [
          Container(height: 550, color: Colors.black),
          const SizedBox(height: 20),
          Expanded(child: Container(color: Colors.black)),
        ],
      ),
    );
  }
}

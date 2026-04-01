import 'package:anime_app/models/anime.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AnimeDetailPage extends StatelessWidget {
  final Anime anime;
  final List<Anime>
  trendingList; // 1. Trending list add ki taaki related dikha sakein

  const AnimeDetailPage({
    super.key,
    required this.anime,
    this.trendingList = const [], // Default empty list
  });

  Future<void> _launchTrailer(String? url, BuildContext context) async {
    final String finalUrl =
        (url != null && url.isNotEmpty)
            ? url
            : "https://www.youtube.com/watch?v=1qyVou-nZ7A";

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
      await launchUrl(uri, mode: LaunchMode.inAppWebView);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Stack(
              children: [
                Container(
                  height: 450,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        anime.trailerThumbnailUrl ?? anime.imageUrl,
                      ),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.6),
                        BlendMode.darken,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 40,
                  left: 10,
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          anime.imageUrl,
                          height: 180,
                          width: 120,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              anime.title,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "Year: ${anime.year ?? 'TBA'} | ★ ${anime.score ?? 'N/A'}",
                              style: const TextStyle(
                                color: Colors.redAccent,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "Genres: ${anime.genres.join(', ')}",
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Play Button
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () => _launchTrailer(anime.trailerUrl, context),
                  icon: const Icon(Icons.play_arrow),
                  label: const Text("PLAY TRAILER"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ),

            // Synopsis
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Synopsis",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                anime.synopsis ?? "No description available.",
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 15,
                  height: 1.5,
                ),
              ),
            ),

            // 2. Updated Trending Related Section
            if (trendingList.isNotEmpty) ...[
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Trending Related",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              _buildRelatedSection(context),
            ],
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // 3. Dynamic Related Section (Boxes ki jagah images)
  Widget _buildRelatedSection(BuildContext context) {
    return SizedBox(
      height: 170,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 20),
        itemCount: trendingList.length,
        itemBuilder: (context, index) {
          final relatedAnime = trendingList[index];
          return GestureDetector(
            onTap: () {
              // Same page par naye anime ke sath navigate karein
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder:
                      (_) => AnimeDetailPage(
                        anime: relatedAnime,
                        trendingList: trendingList,
                      ),
                ),
              );
            },
            child: Container(
              width: 110,
              margin: const EdgeInsets.only(right: 15),
              child: Column(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        relatedAnime.imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    relatedAnime.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

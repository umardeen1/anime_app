class Anime {
  final int malId;
  final String title;
  final String imageUrl; // Ye poster image hai
  final String? trailerThumbnailUrl; // Ye background trailer thumbnail hai
  final String? synopsis;
  final double? score;
  final int? year;
  final String? trailerUrl;
  final List<String> genres;

  Anime({
    required this.malId,
    required this.title,
    required this.imageUrl,
    this.trailerThumbnailUrl, // Add this
    this.synopsis,
    this.score,
    this.year,
    this.trailerUrl,
    required this.genres,
  });

  factory Anime.fromJson(Map<String, dynamic> json) {
    return Anime(
      malId: json['mal_id'],
      title: json['title'] ?? 'Unknown',
      imageUrl: json['images']['jpg']['large_image_url'],

      // Yahan check karein ki 'url' key hi use ho rahi hai
      trailerUrl: json['trailer']?['url'],

      // Thumbnail ke liye ye path:
      trailerThumbnailUrl: json['trailer']?['images']?['maximum_image_url'],

      synopsis: json['synopsis'],
      score: (json['score'] as num?)?.toDouble(),
      year: json['year'],
      genres:
          (json['genres'] as List?)?.map((g) => g['name'] as String).toList() ??
          [],
    );
  }
}

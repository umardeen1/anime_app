import 'dart:convert';
import 'package:anime_app/models/anime.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "https://api.jikan.moe/v4/top/anime?type=movie";

  Future<List<Anime>> getTopAnime() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final List data = json.decode(response.body)['data'];
      return data.map((item) => Anime.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load anime');
    }
  }
}

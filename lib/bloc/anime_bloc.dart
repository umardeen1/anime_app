import 'package:anime_app/models/anime.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/api_service.dart';

// Event definitions
abstract class AnimeEvent {}

class FetchAnimeData extends AnimeEvent {}

class SearchAnimeEvent extends AnimeEvent {
  final String query;
  SearchAnimeEvent(this.query);
}

// State definitions
abstract class AnimeState {}

class AnimeInitial extends AnimeState {}

class AnimeLoading extends AnimeState {}

class AnimeLoaded extends AnimeState {
  final List<Anime> trending;
  final List<Anime> upcoming;
  final Anime randomAnime;
  AnimeLoaded(this.trending, this.upcoming, this.randomAnime);

  get anime => null;
}

class AnimeError extends AnimeState {
  final String message;
  AnimeError(this.message);
}

// Bloc implementation
class AnimeBloc extends Bloc<AnimeEvent, AnimeState> {
  final ApiService apiService;
  AnimeBloc(this.apiService) : super(AnimeInitial()) {
    on<FetchAnimeData>((event, emit) async {
      emit(AnimeLoading());
      try {
        final data = await apiService.getTopAnime();
        emit(AnimeLoaded(data, data.reversed.toList(), data[0]));
      } catch (e) {
        emit(AnimeError(e.toString()));
      }
    });
    on<SearchAnimeEvent>(_onSearchAnime);
  }

  Future<void> _onSearchAnime(
    SearchAnimeEvent event,
    Emitter<AnimeState> emit,
  ) async {
    emit(AnimeLoading());
    try {
      // Replace with actual API call or data fetching logic
      // Example: final animes = await someApi.searchAnime(event.query);
      // For now, emit an empty list or mock data
      final animes = <Anime>[]; // Mock: replace with real data
      emit(
        AnimeLoaded(
          animes,
          animes.reversed.toList(),
          animes.isNotEmpty
              ? animes[0]
              : Anime(malId: 0, title: '', imageUrl: '', genres: []),
        ),
      );
    } catch (e) {
      emit(AnimeError('Failed to search anime: ${e.toString()}'));
    }
  }
}

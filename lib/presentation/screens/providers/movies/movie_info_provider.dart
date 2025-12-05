import 'package:flutter_riverpod/legacy.dart';
import '../../../../domain/domain.dart';
import '../providers.dart';

final movieInfoProvider = StateNotifierProvider<MovieInfoProvider, Map<String, Movie>>((ref) {
  final movieRepository = ref.watch(movieRespositoryProvider);

  return MovieInfoProvider(movieRepository.getMovieById);
});

typedef MoviesCallback = Future<Movie> Function(String movieID);

class MovieInfoProvider extends StateNotifier<Map<String, Movie>> {
  final MoviesCallback getMovie;

  MovieInfoProvider(this.getMovie) : super({});

  Future<void> loadMovieInfo(String movieID) async {
    if (state[movieID] != null) return;

    final movie = await getMovie(movieID);
    state = {...state, movieID: movie};
  }
}

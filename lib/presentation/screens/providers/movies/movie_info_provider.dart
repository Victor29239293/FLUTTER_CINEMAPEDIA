import 'package:flutter_riverpod/legacy.dart';
import '../../../../domain/domain.dart';
import '../providers.dart';

final movieInfoProvider =
    StateNotifierProvider<MovieInfoProvider, Map<String, Movie>>((ref) {
      final movieRepository = ref.watch(movieRespositoryProvider);

      return MovieInfoProvider(movieRepository.getMovieById);
    });

final recommendedMoviesProvider =
    StateNotifierProvider<RecommendedMoviesProvider, Map<String, List<Movie>>>((
      ref,
    ) {
      final movieRepository = ref.watch(movieRespositoryProvider);

      return RecommendedMoviesProvider(movieRepository.getRecommendedMovies);
    });

typedef MoviesCallback = Future<Movie> Function(String movieID);
typedef RecommendedMoviesCallback =
    Future<List<Movie>> Function(String movieID);

class MovieInfoProvider extends StateNotifier<Map<String, Movie>> {
  final MoviesCallback getMovie;

  MovieInfoProvider(this.getMovie) : super({});

  Future<void> loadMovieInfo(String movieID) async {
    if (state[movieID] != null) return;

    final movie = await getMovie(movieID);
    state = {...state, movieID: movie};
  }
}

class RecommendedMoviesProvider
    extends StateNotifier<Map<String, List<Movie>>> {
  final RecommendedMoviesCallback getRecommendedMovies;

  RecommendedMoviesProvider(this.getRecommendedMovies) : super({});

  Future<void> loadRecommendedMovies(String movieID) async {
    if (state[movieID] != null) return;

    final movies = await getRecommendedMovies(movieID);
    state = {...state, movieID: movies};
  }
}

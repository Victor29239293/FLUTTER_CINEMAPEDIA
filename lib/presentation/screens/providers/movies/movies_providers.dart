import 'package:flutter_cinemapedia/presentation/screens/providers/movies/movies_repository_provider.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../../../domain/entities/movie.dart';

final nowPlayingMoviesProvider =
    StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {
      final fetchMoreMovies = ref
          .watch(movieRespositoryProvider)
          .gestNowPlaying;

      return MoviesNotifier(fetchMoreMovies: fetchMoreMovies);
    });

final popularMoviesProvider =
    StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {
      final fetchMoreMovies = ref.watch(movieRespositoryProvider).gestPopular;

      return MoviesNotifier(fetchMoreMovies: fetchMoreMovies);
    });

final upComingMoviesProvider =
    StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {
      final fetchMoreMovies = ref.watch(movieRespositoryProvider).gestUpcoming;

      return MoviesNotifier(fetchMoreMovies: fetchMoreMovies);
    });

final topRatedMoviesProvider =
    StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {
      final fetchMoreMovies = ref.watch(movieRespositoryProvider).gestTopRated;

      return MoviesNotifier(fetchMoreMovies: fetchMoreMovies);
    });


typedef MoviesCallback = Future<List<Movie>> Function({int page});

class MoviesNotifier extends StateNotifier<List<Movie>> {
  int currentPage = 0;
  bool isloading = false;
  MoviesCallback fetchMoreMovies;
  MoviesNotifier({required this.fetchMoreMovies}) : super([]);

  Future<void> loadNextPage() async {
    if (isloading) return;
    isloading = true;
    currentPage++;
    final List<Movie> newMovies = await fetchMoreMovies(page: currentPage);

    state = [...state, ...newMovies];
    isloading = false;
  }
}

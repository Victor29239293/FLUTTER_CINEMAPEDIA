import 'package:flutter_cinemapedia/presentation/screens/providers/movies/movies_repository_provider.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../../../domain/domain.dart';

final movieTrailerProvider =
    StateNotifierProvider<
      MovieTrailerProvider,
      Map<String, List<MovieTrailer>>
    >((ref) {
      final moviesRepository = ref.watch(movieRespositoryProvider);

      return MovieTrailerProvider(moviesRepository.getMovieTrailer);
    });
typedef MovieTrailerCallback =
    Future<List<MovieTrailer>> Function(String movieID);

class MovieTrailerProvider
    extends StateNotifier<Map<String, List<MovieTrailer>>> {
  final MovieTrailerCallback getMovieTrailer;
  MovieTrailerProvider(this.getMovieTrailer) : super({});

  Future<void> loadMovieTrailer(String movieID) async {
    if (state[movieID] != null) return;

    final trailers = await getMovieTrailer(movieID);
    state = {...state, movieID: trailers};
  }

 
}

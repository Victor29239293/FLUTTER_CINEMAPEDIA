import '../entities/movie.dart';

abstract class MoviesRepository {
  Future<List<Movie>> getWatchlistMovieIds({int page = 1});
}

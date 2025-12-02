import '../entities/movie.dart';

abstract class MovieDatasource {
  Future<List<Movie>> getWatchlistMovieIds({int page = 1});
}

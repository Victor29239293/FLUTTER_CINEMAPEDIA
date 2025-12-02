import '../entities/movie.dart';

abstract class MoviesRepository {
  Future<List<Movie>> gestNowPlaying({int page = 1});
}

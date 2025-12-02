import '../entities/movie.dart';

abstract class MovieDatasource {
  Future<List<Movie>> gestNowPlaying({int page = 1});
}

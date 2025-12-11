import '../entities/movie.dart';

abstract class LocalStorageDatasource {
  Future<void> toggleFavoriteMovie(Movie movie);
  Future<bool> isFavoriteMovie(int movieId);
  Future<List<String>> getFavoriteMovies({int limit = 10, int offset = 0});
}

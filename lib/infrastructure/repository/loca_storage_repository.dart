import 'package:flutter_cinemapedia/domain/repository/loca_storage_repository.dart';
import '../../domain/datasource/local_storage_datasource.dart';
import '../../domain/entities/movie.dart';

class LocalStorageRepositoryImpl extends LocalStorageRepository {
  final LocalStorageDatasource localStorageDatasource;

  LocalStorageRepositoryImpl(this.localStorageDatasource);

  @override
  Future<void> toggleFavoriteMovie(Movie movie) {
    return localStorageDatasource.toggleFavoriteMovie(movie);
  }

  @override
  Future<bool> isFavoriteMovie(int movieId) {
    return localStorageDatasource.isFavoriteMovie(movieId);
  }

  @override
  Future<List<String>> getFavoriteMovies({int limit = 10, int offset = 0}) {
    return localStorageDatasource.getFavoriteMovies(
        limit: limit, offset: offset);
  }
}
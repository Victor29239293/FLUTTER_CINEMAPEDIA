import 'package:drift/drift.dart';
import 'package:flutter_cinemapedia/domain/entities/movie.dart';
import '../../config/database/database.dart';
import '../../domain/datasource/local_storage_datasource.dart';

class DriftDatasource extends LocalStorageDatasource {
  final AppDatabase database;
  DriftDatasource([AppDatabase? database]) : database = database ?? db;

  @override
  Future<List<String>> getFavoriteMovies({
    int limit = 10,
    int offset = 0,
  }) async {
    //Construir el query
    final query = database.select(database.favoriteMovies)
      ..limit(limit, offset: offset);

    //Ejecutar el query
    final favoriteMovies = await query.get();

    final movies = favoriteMovies
        .map(
          (e) => Movie(
            id: e.movieId,
            backdropPath: e.backdropPath,
            originalTitle: e.originalTitle,
            posterPath: e.posterPath,
            title: e.title,
            voteAverage: e.voteAverage,
            adult: false,
            genreIds: [],
            originalLanguage: '',
            overview: '',
            popularity: 0.0,
            releaseDate: '',
            video: false,
            voteCount: 0,
          ),
        )
        .toList();

    return movies.map((e) => e.posterPath ?? '').toList();
  }

  @override
  Future<bool> isFavoriteMovie(int movieId) async {
    //Construir el query
    final query = database.select(database.favoriteMovies)
      ..where((tbl) => tbl.movieId.equals(movieId));

    //Ejecutar el query
    final favoriteMovie = await query.getSingleOrNull();

    //Retornar el resultado
    return favoriteMovie != null;
  }

  @override
  Future<void> toggleFavoriteMovie(Movie movie) async {
    //Construir el query
    final isFavorite = await isFavoriteMovie(movie.id);

    if (isFavorite) {
      //Eliminar de favoritos
      final query = database.delete(database.favoriteMovies)
        ..where((tbl) => tbl.movieId.equals(movie.id));
      await query.go();
      return;
    } else {
      //Agregar a favoritos
      await database
          .into(database.favoriteMovies)
          .insert(
            FavoriteMoviesCompanion(
              movieId: Value(movie.id),
              backdropPath: Value(movie.backdropPath ?? ''),
              originalTitle: Value(movie.originalTitle),
              posterPath: Value(movie.posterPath ?? ''),
              title: Value(movie.title),
              voteAverage: Value(movie.voteAverage),
            ),
          );
    }
  }
}

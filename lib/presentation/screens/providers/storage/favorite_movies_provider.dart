import 'package:flutter_cinemapedia/domain/repository/loca_storage_repository.dart';
import 'package:flutter_cinemapedia/presentation/screens/providers/storage/local_storage_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../domain/entities/movie.dart';

final favoriteMoviesProvider = StateNotifierProvider((ref) {
  final localStorageRepository = ref.watch(LocalStorageProvider);

  return FavoriteMoviesNotifier(localStorageRepository: localStorageRepository);
});

class FavoriteMoviesNotifier extends StateNotifier<Map<int, Movie>> {
  int page = 0;
  final LocalStorageRepository localStorageRepository;

  FavoriteMoviesNotifier({required this.localStorageRepository}) : super({});

  Future<List<Movie>> loadNextPage() async {
    final movies = await localStorageRepository.getFavoriteMovies(
      limit: 10,
      offset: page * 10,
    );

    page++;
    final tempMovie = <int, Movie>{};
    for (final movie in movies) {
      tempMovie[movie.id] = movie;
    }

    state = {...state, ...tempMovie};
    return movies;
  }

  Future<void> toggleFavoriteMovie(Movie movie) async {
    try {
      final isFavorite = await localStorageRepository.isFavoriteMovie(movie.id);

      // Realizar la operación en base de datos
      await localStorageRepository.toggleFavoriteMovie(movie);

      // Actualizar el estado después de guardar en la base de datos
      if (isFavorite) {
        // Si era favorito, lo removemos del estado
        state = {...state}..remove(movie.id);
      } else {
        // Si no era favorito, lo agregamos al estado
        state = {...state, movie.id: movie};
      }
    } catch (e) {
      print('Error toggling favorite: $e');
      rethrow;
    }
  }
}

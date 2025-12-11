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

  Future<void> toggleFavoriteMovie(Movie movie) async {
    final isfavorite = await localStorageRepository.isFavoriteMovie(movie.id);

    await localStorageRepository.toggleFavoriteMovie(movie);

    if (isfavorite) {
      state.remove(movie.id);
      state = {...state};
      return;
    } 

    state = {...state, movie.id: movie};
    
  }
}

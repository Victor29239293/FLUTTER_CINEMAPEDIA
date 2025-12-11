import 'package:flutter_cinemapedia/presentation/screens/providers/storage/local_storage_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final isFavoriteProvider = FutureProvider.family<bool, int>((ref, movieId) {
  final localStorageRepository = ref.watch(LocalStorageProvider);
  return localStorageRepository.isFavoriteMovie(movieId);
});

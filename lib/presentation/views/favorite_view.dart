import 'package:flutter/material.dart';
import 'package:flutter_cinemapedia/presentation/screens/providers/storage/favorite_movies_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../screens/widgets/movies/movie_masonry.dart';

class FavoriteView extends ConsumerStatefulWidget {
  const FavoriteView({super.key});

  @override
  ConsumerState<FavoriteView> createState() => _FavoriteViewState();
}

class _FavoriteViewState extends ConsumerState<FavoriteView> {
  @override
  void initState() {
    ref.read(favoriteMoviesProvider.notifier).loadNextPage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final favoriteMovies = ref.watch(favoriteMoviesProvider);
    final movieList = favoriteMovies.values.toList();
    final color = Theme.of(context).colorScheme.primary;

    if (movieList.isEmpty) {
      return Scaffold(
        body: Center(
          child: Column(
            children: [
              Icon(Icons.favorite_outline, size: 100, color: color),
              Text(
                'No hay peliculas favoritas aun',
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: MovieMasonry(
        movies: movieList,
        loadNextPage: () =>
            ref.read(favoriteMoviesProvider.notifier).loadNextPage(),
      ),
    );
  }
}

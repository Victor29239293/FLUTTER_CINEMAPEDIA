import 'package:flutter/material.dart';
import 'package:flutter_cinemapedia/presentation/screens/providers/movies/movies_providers.dart';
import 'package:flutter_cinemapedia/presentation/screens/widgets/movies/movie_masonry.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PopularView extends ConsumerStatefulWidget {
  const PopularView({super.key});

  @override
  ConsumerState<PopularView> createState() => _PopularViewState();
}

class _PopularViewState extends ConsumerState<PopularView> {
  @override
  void initState() {
    ref.read(popularMoviesProvider.notifier).loadNextPage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final popularMovies = ref.watch(popularMoviesProvider);
    final movieList = popularMovies.toList();
    return Scaffold(
      
      body: MovieMasonry(
        movies: movieList,
        loadNextPage: () async {
          await ref.read(popularMoviesProvider.notifier).loadNextPage();
          return ref.read(popularMoviesProvider);
        },
      ),
    );
  }
}

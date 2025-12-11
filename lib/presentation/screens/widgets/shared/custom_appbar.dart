import 'package:flutter/material.dart';
import 'package:flutter_cinemapedia/presentation/screens/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../domain/domain.dart';
import '../../../delegates/search_movie_delegate.dart';

class CustomAppbar extends ConsumerWidget {
  const CustomAppbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final titleStyle = Theme.of(context).textTheme.titleMedium?.copyWith(
      color: colors.onSurface,
      fontWeight: FontWeight.w800,
      letterSpacing: -0.5,
      fontSize: 22,
    );

    return SafeArea(
      
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: SizedBox(
          width: double.infinity,
          child: Row(
            children: [
              Icon(Icons.movie_outlined, color: colors.primary, size: 30),
              const SizedBox(width: 5),
              Text('Cinemapedia', style: titleStyle),

              const Spacer(),
              IconButton(
                onPressed: () {
                  final searchMovies = ref.read(searchMoviesProvider);
                  final searchQuery = ref.read(searchQueryProvider);
                  showSearch<Movie?>(
                    query: searchQuery,
                    context: context,
                    delegate: SearchMovieDelegate(
                      initialMovies: searchMovies,
                      searchMovies: ref
                          .read(searchMoviesProvider.notifier)
                          .searchMoviesByQuery,
                    ),
                  ).then((movie) {
                    if (movie == null) return;
                    // ignore: use_build_context_synchronously
                    context.push('home/0/movies/${movie.id}');
                  });
                },
                icon: const Icon(Icons.search),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

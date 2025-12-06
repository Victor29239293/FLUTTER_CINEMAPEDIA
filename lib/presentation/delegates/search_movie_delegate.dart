import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import '../../config/helpers/human_formats.dart';
import '../../domain/domain.dart';

typedef SearchMovieCallback = Future<List<Movie>> Function(String query);

class SearchMovieDelegate extends SearchDelegate<Movie?> {
  final SearchMovieCallback? searchMovies;

  List<Movie> initialMovies;

  StreamController<List<Movie>> debounceMovies =
      StreamController<List<Movie>>.broadcast();

  StreamController<bool> isLoadingStreamController =
      StreamController<bool>.broadcast();

  Timer? _debounceTimer;

  void clearStream() {
    debounceMovies.close();
  }

  void _onQueryChanged(String query) {
    isLoadingStreamController.add(true);
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      // if (query.isEmpty) {
      //   debounceMovies.add([]);
      //   return;
      // }
      final movies = await searchMovies?.call(query) ?? [];
      debounceMovies.add(movies);
      initialMovies = movies;
      isLoadingStreamController.add(false);
    });
  }

  SearchMovieDelegate({
    required this.searchMovies,
    required this.initialMovies,
  });

  @override
  String get searchFieldLabel => 'Buscar películas';

  Widget buildResultsAndSuggestions() {
    return StreamBuilder(
      initialData: initialMovies,
      stream: debounceMovies.stream,

      builder: (context, snapshot) {
        final movies = snapshot.data ?? [];

        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: (context, index) {
            final movie = movies[index];
            return _MovieItem(
              movie: movie,
              onMovieTap: (context, movie) {
                clearStream();
                close(context, movie);
              },
            );
          },
        );
      },
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      StreamBuilder(
        stream: isLoadingStreamController.stream,
        builder: (context, snapshot) {
          if (snapshot.data ?? false) {
            return SpinPerfect(
              duration: const Duration(seconds: 5),
              spins: 10,
              infinite: true,
              child: IconButton(
                icon: const Icon(Icons.refresh_rounded),
                onPressed: () => query = '',
              ),
            );
          }
          return FadeIn(
            animate: query.isNotEmpty,
            child: IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () => query = '',
            ),
          );
        },
      ),
      // SpinPerfect(
      //   duration: const Duration(seconds: 20),
      //   animate: query.isNotEmpty,
      //   child: IconButton(
      //     icon: const Icon(Icons.refresh_rounded),
      //     onPressed: () => query = '',
      //   ),
      // ),

      //
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_ios_new_rounded),
      onPressed: () {
        clearStream();
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildResultsAndSuggestions();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    _onQueryChanged(query);
    return buildResultsAndSuggestions();
  }
}

class _MovieItem extends StatelessWidget {
  final Movie movie;
  final Function onMovieTap;

  const _MovieItem({required this.movie, required this.onMovieTap});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textStyles = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () => onMovieTap(context, movie),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          children: [
            SizedBox(
              width: size.width * 0.2,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  movie.posterPath ?? '',
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return FadeIn(child: child);
                  },
                ),
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              width: size.width * 0.7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    style: textStyles.titleMedium,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  Text(
                    (movie.overview.trim().isEmpty)
                        ? 'No description available'
                        : movie.overview,
                    style: textStyles.bodySmall,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                  ),
                  SizedBox(
                    child: Row(
                      children: [
                        Icon(
                          Icons.star_half_outlined,
                          color: Colors.yellow.shade800,
                        ),
                        Text(
                          '${HumanFormats.number(movie.popularity, 1)}',
                          style: textStyles.bodySmall,
                        ),
                      ],
                    ),
                  ),

                  // )
                ],
              ),
            ),

            // const SizedBox(width: 10),
          ],
        ),
      ),
    );
  }
}

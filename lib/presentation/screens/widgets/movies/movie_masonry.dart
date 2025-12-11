import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';

import '../../../../domain/domain.dart';

class MovieMasonry extends StatefulWidget {
  final List<Movie> movies;
  final Future<List<Movie>> Function()? loadNextPage;
  const MovieMasonry({
    super.key,
    required this.movies,
    required this.loadNextPage,
  });

  @override
  State<MovieMasonry> createState() => _MovieMasonryState();
}

class _MovieMasonryState extends State<MovieMasonry> {
  bool isLoading = false;
  bool isLastPage = false;
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (scrollController.position.pixels + 200 >=
        scrollController.position.maxScrollExtent) {
      _loadNextPage();
    }
  }

  void _loadNextPage() async {
    if (isLoading || isLastPage) return;
    if (widget.loadNextPage == null) return;

    isLoading = true;
    final movie = await widget.loadNextPage!();
    isLoading = false;

    if (movie.isEmpty) {
      isLastPage = true;
    }
  }

  @override
  void dispose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: MasonryGridView.count(
        controller: scrollController,
        crossAxisCount: 3,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        itemCount: widget.movies.length,
        itemBuilder: (context, index) {
          final movie = widget.movies[index];
          if (index == 1) {
            return Column(
              children: [
                const SizedBox(height: 30),
                MoviePosterLink(movie: movie),
              ],
            );
          }
          return MoviePosterLink(movie: movie);
        },
      ),
    );
  }
}

class MoviePosterLink extends StatelessWidget {
  final Movie movie;
  const MoviePosterLink({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.go('/home/2/movies/${movie.id}');
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.network(
          movie.posterPath ?? '',
          height: 200,
          width: double.infinity,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              return GestureDetector(
                onTap: () {
                  context.push('/home/1/movies/${movie.id}');
                },
                child: Image.asset(
                  'assets/loaders/bottle-loader.gif',
                  width: 135,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              );
            }

            return FadeIn(child: child);
          },
        ),
      ),
    );
  }
}

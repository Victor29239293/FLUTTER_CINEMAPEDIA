import 'package:animate_do/animate_do.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../domain/domain.dart';
import '../shared/shimmer_loading.dart';

class MoviesSlidershow extends StatelessWidget {
  final List<Movie> movies;
  const MoviesSlidershow({super.key, required this.movies});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return RepaintBoundary(
      child: SizedBox(
        height: 215,
        width: double.infinity,
        child: Swiper(
          viewportFraction: 0.8,
          scale: 0.9,
          autoplay: true,
          pagination: SwiperPagination(
            margin: const EdgeInsets.only(top: 0),
            builder: DotSwiperPaginationBuilder(
              activeColor: colors.primary,
              color: colors.secondary,
              size: 8,
              activeSize: 10,
            ),
          ),
          itemCount: movies.length,
          itemBuilder: (context, index) {
            final movie = movies[index];
            return _Slide(
              movie: movie,
              // onPressed: () {
              //   context.push('/movies/${movie.id}');
              // },
            );
          },
        ),
      ),
    );
  }
}

class _Slide extends StatelessWidget {
  final Movie movie;

  const _Slide({required this.movie});

  @override
  Widget build(BuildContext context) {
    final decoration = BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      boxShadow: const [
        BoxShadow(color: Colors.black45, blurRadius: 10, offset: Offset(0, 10)),
      ],
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: DecoratedBox(
        decoration: decoration,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.network(
            movie.backdropPath ?? '',
            fit: BoxFit.cover,
            cacheHeight: 215,
            cacheWidth: 400,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) {
                return GestureDetector(
                  onTap: () {
                    context.push('/home/0/movies/${movie.id}');
                  },
                  child: FadeIn(child: child),
                );
              }

              return GestureDetector(
                onTap: () {
                  context.push('/home/0/movies/${movie.id}');
                },
                child: ShimmerLoading(width: 150, height: 225),
              );
            },

            errorBuilder: (context, error, stackTrace) {
              return GestureDetector(
                onTap: () {
                  context.push('/home/0/movies/${movie.id}');
                },
                child: Container(
                  width: 150,
                  height: 225,
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    Icons.image_not_supported,
                    color: Colors.grey[600],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

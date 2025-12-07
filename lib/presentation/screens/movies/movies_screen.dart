import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cinemapedia/presentation/screens/providers/actors/actors_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../../domain/domain.dart';
import '../providers/movies/movie_info_provider.dart';
import '../providers/movies/movie_trailer_provider.dart';

class MoviesScreen extends ConsumerStatefulWidget {
  static const name = 'movies_screen';
  final String movieID;

  const MoviesScreen({super.key, required this.movieID});

  @override
  MoviesScreenState createState() => MoviesScreenState();
}

class MoviesScreenState extends ConsumerState<MoviesScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(movieInfoProvider.notifier).loadMovieInfo(widget.movieID);
    ref.read(actorMoviesProvider.notifier).loadMovieInfo(widget.movieID);
    ref.read(movieTrailerProvider.notifier).loadMovieTrailer(widget.movieID);
  }

  @override
  Widget build(BuildContext context) {
    final Movie? movie = ref.watch(movieInfoProvider)[widget.movieID];
    final trailersMap = ref.watch(movieTrailerProvider);
    final trailers = trailersMap[widget.movieID];

    if (movie == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final videoId = trailers != null && trailers.isNotEmpty
        ? trailers.first.key
        : '';

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: CustomScrollView(
        slivers: [
          _CustomSliverAppBar(movie: movie),
          SliverToBoxAdapter(child: SizedBox(height: 20)),
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return _MovieDetails(movie: movie, videoId: videoId);
            }, childCount: 1),
          ),
        ],
      ),
    );
  }
}

class _MovieDetails extends StatelessWidget {
  final Movie movie;
  final String videoId;

  const _MovieDetails({required this.movie, required this.videoId});

  Future<void> openTrailer(String videoId) async {
    final url = 'https://www.youtube.com/watch?v=$videoId'; // Zootopia 2
    if (!await launchUrl(Uri.parse(url))) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    // final color = Theme.of(context).colorScheme;
    final textStyle = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  movie.posterPath ?? 'https://i.stack.imgur.com/GNhxO.png',
                  width: size.width * 0.3,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 10),

              //* Descripcion
              SizedBox(
                width: (size.width - 40) * 0.7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(movie.title, style: textStyle.titleLarge),
                    Text(
                      movie.overview,
                      style: textStyle.bodyMedium,
                      maxLines: 10,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        Padding(
          padding: EdgeInsets.all(8),
          child: Wrap(
            spacing: 10,
            children: movie.genreIds
                .map(
                  (genre) => Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Chip(
                      label: Text(genre),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),

        // TODO: Mostrar Actores ListView
        FadeInRight(child: _ActorByMovies(movieID: movie.id.toString())),
        // SizedBox(height: 10),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            'Trailer',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 10),
        MovieTrailer(videoId: videoId),
        SizedBox(height: 10),
      ],
    );
  }
}

class MovieTrailer extends StatefulWidget {
  final String videoId;

  const MovieTrailer({super.key, required this.videoId});

  @override
  State<MovieTrailer> createState() => _MovieTrailerState();
}

class _MovieTrailerState extends State<MovieTrailer> {
  YoutubePlayerController? _controller;
  bool _isPlaying = false;

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _togglePlayer() {
    if (_isPlaying) {
      setState(() {
        _controller?.dispose();
        _controller = null;
        _isPlaying = false;
      });
    } else {
      setState(() {
        _controller = YoutubePlayerController(
          initialVideoId: widget.videoId,
          flags: const YoutubePlayerFlags(
            autoPlay: true,
            mute: false,
            controlsVisibleAtStart: true,
          ),
        );
        _isPlaying = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Si no hay videoId, mostrar un placeholder
    if (widget.videoId.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Container(
            height: 200,
            width: double.infinity,
            color: Colors.grey[300],
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.movie_outlined, size: 64, color: Colors.grey[600]),
                  SizedBox(height: 8),
                  Text(
                    'No hay trailer disponible',
                    style: TextStyle(color: Colors.grey[600], fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          height: 200,
          width: double.infinity,
          child: _isPlaying && _controller != null
              ? YoutubePlayer(
                  controller: _controller!,
                  showVideoProgressIndicator: true,
                  onEnded: (metadata) {
                    setState(() {
                      _isPlaying = false;
                      _controller?.dispose();
                      _controller = null;
                    });
                  },
                )
              : Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      'https://img.youtube.com/vi/${widget.videoId}/0.jpg',
                      fit: BoxFit.cover,
                    ),
                    Material(
                      color: Colors.black26,
                      child: InkWell(
                        onTap: _togglePlayer,
                        child: Center(
                          child: Icon(
                            Icons.play_circle_fill,
                            color: Colors.white,
                            size: 64,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class _ActorByMovies extends ConsumerWidget {
  final String movieID;
  const _ActorByMovies({required this.movieID});

  @override
  Widget build(BuildContext context, ref) {
    final actorsByMovie = ref.watch(actorMoviesProvider);

    if (actorsByMovie[movieID] == null) {
      return const SizedBox();
    }

    final actors = actorsByMovie[movieID]!;
    return SizedBox(
      height: 300,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: actors.length,
        itemBuilder: (context, index) {
          final actor = actors[index];
          return Container(
            padding: EdgeInsets.all(8),
            width: 135,
            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    actor.profilePath,
                    width: 135,
                    height: 180,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress != null) {
                        return Image.asset(
                          'assets/loaders/tri-spinner.gif',
                          width: 135,
                          height: 150,
                          fit: BoxFit.cover,
                        );
                      }
                      return FadeIn(child: child);
                    },
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  actor.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),

                Text(
                  actor.character ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _CustomSliverAppBar extends StatelessWidget {
  final Movie movie;
  const _CustomSliverAppBar({required this.movie});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SliverAppBar(
      backgroundColor: Colors.black,
      expandedHeight: size.height * 0.7,
      foregroundColor: Colors.white,

      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [
            SizedBox.expand(
              child: Image.network(
                movie.posterPath ?? 'https://i.stack.imgur.com/GNhxO.png',
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress != null) return const SizedBox();
                  return child;
                },
              ),
            ),

            const SizedBox.expand(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black87],
                    stops: [0.7, 1.0],
                  ),
                ),
              ),
            ),

            const SizedBox.expand(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    stops: [0.0, 0.4],
                    colors: [Colors.black87, Colors.transparent],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

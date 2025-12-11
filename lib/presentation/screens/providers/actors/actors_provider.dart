import 'package:flutter_cinemapedia/presentation/screens/providers/actors/actor_respository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../domain/domain.dart';

final actorMoviesProvider =
    StateNotifierProvider<ActorMoviesProvider, Map<String, List<Actor>>>((ref) {
      final actorRepository = ref.watch(actorRepositoryProvider);

      return ActorMoviesProvider(actorRepository.getActorsByMovie);
    });

typedef MoviesCallback = Future<List<Actor>> Function(String movieID);

class ActorMoviesProvider extends StateNotifier<Map<String, List<Actor>>> {
  final MoviesCallback getActorsByMovie;

  ActorMoviesProvider(this.getActorsByMovie) : super({});

  Future<void> loadMovieInfo(String movieID) async {
    if (state[movieID] != null) return;

    final actors = await getActorsByMovie(movieID);
    state = {...state, movieID: actors};
  }
}

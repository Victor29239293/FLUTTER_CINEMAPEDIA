
import 'package:flutter_cinemapedia/infrastructure/datasource/actor_moviedb_datasource.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../infrastructure/repository/actor_movie_respository_impl.dart';

final actorRepositoryProvider = Provider((ref) {
  
  return ActorMovieRespositoryImpl(ActorMoviedbDatasource() );
});

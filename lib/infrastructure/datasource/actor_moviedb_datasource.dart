import 'package:dio/dio.dart';
import 'package:flutter_cinemapedia/infrastructure/mappers/actor_mappers.dart';
import '../../config/constant/environment.dart';
import '../../domain/datasource/actor_datasource.dart';
import '../../domain/entities/actor.dart';
import '../models/moviedb/credits_response.dart';

class ActorMoviedbDatasource extends ActorDatasource {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.themoviedb.org/3',
      queryParameters: {
        'api_key': Environment.theMovieDbApiKey,
        'language': 'es-MX',
      },
    ),
  );

  @override
  Future<List<Actor>> getActorsByMovie(String movieID) async {
    final response = await dio.get('/movie/$movieID/credits');

    final castResponse = CreditsResponse.fromJson(response.data);

    List<Actor> actors = castResponse.cast
        .map((cast) => ActorMappers.castToEntity(cast))
        .toList();

    return actors;
  }
}

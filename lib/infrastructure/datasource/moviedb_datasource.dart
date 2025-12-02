import 'package:dio/dio.dart';
import 'package:flutter_cinemapedia/infrastructure/models/moviedb/moviedb_response.dart';
import '../../config/constant/environment.dart';
import '../../domain/datasource/movie_datasource.dart';
import '../../domain/entities/movie.dart';
import '../mappers/movie_mapper.dart';

class MoviedbDatasource extends MovieDatasource {
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
  Future<List<Movie>> gestNowPlaying({int page = 1}) async {
    final response = await dio.get('/movie/now_playing');
    final movieDBResponse = MovieDbResponse.fromJson(response.data);
    final List<Movie> movies = movieDBResponse.results
        .where((element) => element.posterPath != 'no-poster')
        .map((movieDB) => MovieMapper.movieDBToEntity(movieDB))
        .toList();

    return movies;
  }
}

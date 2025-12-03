import 'package:dio/dio.dart';
import '../../config/constant/environment.dart';
import '../../domain/domain.dart';
import '../infrastructura.dart';


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

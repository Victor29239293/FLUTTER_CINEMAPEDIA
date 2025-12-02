import 'package:flutter_cinemapedia/domain/repository/movies_repository.dart';
import '../../domain/datasource/movie_datasource.dart';
import '../../domain/entities/movie.dart';


class MovieResposityImpl extends MoviesRepository {

  final MovieDatasource datasource;

  MovieResposityImpl( this.datasource);
  
  @override
  Future<List<Movie>> gestNowPlaying({int page = 1}) {
    return datasource.gestNowPlaying(page: page);
  
  }
}

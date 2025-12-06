import '../../domain/domain.dart';

class MovieResposityImpl extends MoviesRepository {
  final MovieDatasource datasource;

  MovieResposityImpl(this.datasource);

  @override
  Future<List<Movie>> gestNowPlaying({int page = 1}) {
    return datasource.gestNowPlaying(page: page);
  }

  @override
  Future<List<Movie>> gestPopular({int page = 1}) {
    return datasource.gestPopular(page: page);
  }

  @override
  Future<List<Movie>> gestUpcoming({int page = 1}) {
    return datasource.gestUpcoming(page: page);
  }

  @override
  Future<List<Movie>> gestTopRated({int page = 1}) {
    return datasource.gestTopRated(page: page);
  }

  @override
  Future<Movie> getMovieById(String movieId) {
    return datasource.getMovieById(movieId);
  }

  @override
  Future<List<Movie>> searchMovies(String query) {
    return datasource.searchMovies(query);
  }
}

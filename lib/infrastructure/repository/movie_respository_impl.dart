import '../../domain/domain.dart';

class MovieResposityImpl extends MoviesRepository {
  final MovieDatasource datasource;

  MovieResposityImpl(this.datasource);

  @override
  Future<List<Movie>> gestNowPlaying({int page = 1}) {
    return datasource.gestNowPlaying(page: page);
  }
}

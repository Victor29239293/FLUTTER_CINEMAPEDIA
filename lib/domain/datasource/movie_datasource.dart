
import '../domain.dart';

abstract class MovieDatasource {
  Future<List<Movie>> gestNowPlaying({int page = 1});
}

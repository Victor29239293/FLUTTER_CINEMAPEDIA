
import '../domain.dart';

abstract class MoviesRepository {
  Future<List<Movie>> gestNowPlaying({int page = 1});
  Future<List<Movie>> gestPopular({int page = 1});
  Future<List<Movie>> gestUpcoming({int page = 1});
  Future<List<Movie>> gestTopRated({int page = 1});

  Future<Movie> getMovieById(String movieId);
  Future<List<Movie>> searchMovies(String query);
  
}


import '../../domain/domain.dart';
import '../infrastructura.dart';
import '../models/moviedb/movie_details.dart';

class MovieMapper {
  static Movie movieDBToEntity(MovieMovieDB movieDB) => Movie(
    adult: movieDB.adult,
    backdropPath: movieDB.backdropPath != ''
        ? 'https://image.tmdb.org/t/p/w500${movieDB.backdropPath}'
        : 'https://i.stack.imgur.com/GNhxO.png',
    genreIds: movieDB.genreIds.map((e) => e.toString()).toList(),
    id: movieDB.id,
    originalLanguage: movieDB.originalLanguage,
    originalTitle: movieDB.originalTitle,
    overview: movieDB.overview,
    popularity: movieDB.popularity,
    posterPath: movieDB.posterPath != ''
        ? 'https://image.tmdb.org/t/p/w500${movieDB.posterPath}'
        : 'no-poster',
    releaseDate: movieDB.releaseDate,
    title: movieDB.title,
    video: movieDB.video,
    voteAverage: movieDB.voteAverage,
    voteCount: movieDB.voteCount,
  );

    static Movie movieDetailsDBToEntity(MovieDetailsDbResponse movieDB) => Movie(
    adult: movieDB.adult,
    backdropPath: movieDB.backdropPath != ''
        ? 'https://image.tmdb.org/t/p/w500${movieDB.backdropPath}'
        : 'https://i.stack.imgur.com/GNhxO.png',
    genreIds: movieDB.genres.map((e) => e.name).toList(),
    id: movieDB.id,
    originalLanguage: movieDB.originalLanguage,
    originalTitle: movieDB.originalTitle,
    overview: movieDB.overview,
    popularity: movieDB.popularity,
    posterPath: movieDB.posterPath != ''
        ? 'https://image.tmdb.org/t/p/w500${movieDB.posterPath}'
        : 'no-poster',
    releaseDate: movieDB.releaseDate,
    title: movieDB.title,
    video: false,
    voteAverage: movieDB.voteAverage,
    voteCount: movieDB.voteCount,
  );
}

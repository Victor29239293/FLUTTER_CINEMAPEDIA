import 'package:flutter_cinemapedia/infrastructure/datasource/moviedb_datasource.dart';
import 'package:flutter_cinemapedia/infrastructure/repository/movie_respository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final movieRespositoryProvider = Provider((ref) {
  
  return MovieResposityImpl(MoviedbDatasource());
});

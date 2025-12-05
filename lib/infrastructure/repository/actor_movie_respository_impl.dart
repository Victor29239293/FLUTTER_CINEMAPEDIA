import '../../domain/datasource/actor_datasource.dart';
import '../../domain/domain.dart';
import '../../domain/repository/actor_repository.dart';

class ActorMovieRespositoryImpl extends ActorRepository {
  final ActorDatasource datasource;

  ActorMovieRespositoryImpl(this.datasource);

  @override
  Future<List<Actor>> getActorsByMovie(String movieID) {
    return datasource.getActorsByMovie(movieID);
  }
}

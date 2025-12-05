import '../domain.dart';

abstract class ActorDatasource {
  Future<List<Actor>> getActorsByMovie(String movieID);
}

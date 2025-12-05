import '../domain.dart';

abstract class ActorRepository {
  Future<List<Actor>> getActorsByMovie(String movieID);
}

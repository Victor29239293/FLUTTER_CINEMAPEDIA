import 'package:go_router/go_router.dart';
import '../../presentation/screens/screens.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      name: HomeScreen.name,
      builder: (_, __) => const HomeScreen(),
      routes: [
        GoRoute(
          path: 'movies/:movieID',
          name: MoviesScreen.name,
          builder: (context, state) {
            final movieID = state.pathParameters['movieID'] ?? 'no-id';
            return MoviesScreen(movieID: movieID);
          },
        ),
      ],
    ),
  ],
);

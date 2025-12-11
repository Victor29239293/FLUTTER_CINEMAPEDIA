import 'package:go_router/go_router.dart';
import '../../presentation/screens/screens.dart';

final appRouter = GoRouter(
  initialLocation: '/home/0',
  routes: [
    GoRoute(
      path: '/home/:page',
      name: HomeScreen.name,
      builder: (context, state) {
        final pageIndex = int.parse(state.pathParameters['page'] ?? '0');
        if (pageIndex < 0 || pageIndex > 2) {
          return HomeScreen(pageIndex: 0);
        }
        return HomeScreen(pageIndex: pageIndex);
      },
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
    GoRoute(path: '/',
    redirect: (_,_) => '/home/0',
    )
  ],
);

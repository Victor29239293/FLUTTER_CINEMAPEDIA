import 'package:flutter_cinemapedia/presentation/views/home_views/popular_view.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/screens/screens.dart';
import '../../presentation/views/views.dart';

final appRouter = GoRouter(
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return HomeScreen(childView: child);
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) {
            return HomeView();
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
        GoRoute(
          path: '/popular',
          builder: (context, state) {
            return PopularView();
          },
        ),
        GoRoute(
          path: '/favorites',
          builder: (context, state) {
            return FavoriteView();
          },
        ),
      ],
    ),
    // GoRoute(
    //   path: '/',
    //   name: HomeScreen.name,
    //   builder: (_, __) =>  HomeScreen(childView: HomeView(),),
    //   routes: [
    //
    //   ],
    // ),
  ],
);

import 'package:flutter/material.dart';
import 'package:flutter_cinemapedia/config/database/database.dart';
import 'package:flutter_cinemapedia/config/router/app_router.dart';
import 'package:flutter_cinemapedia/config/theme/app_theme.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await db
  //     .into(db.favoriteMovies)
  //     .insert(
  //       FavoriteMoviesCompanion.insert(
  //         movieId: 1,
  //         backdropPath: 'backdropPath.png',
  //         originalTitle: 'originalTitle',
  //         posterPath: 'posterPath.png',
  //         title: 'Mi primera pelicula',
  //       ),
  //     );
  final moviesQuery = await db.select(db.favoriteMovies).get();
  print(moviesQuery);
  await dotenv.load(fileName: ".env");
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: AppTheme(isDarkMode: true).getTheme(),
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
    );
  }
}

import 'package:flutter/material.dart';
// import '../../views/views.dart';
import '../../views/popular_view.dart';
import '../../views/views.dart';
import '../widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  static const name = 'home_screen';
  final int pageIndex;

  // final Widget childView;
  HomeScreen({super.key, required this.pageIndex});

  static final viewRoutes = <Widget>[HomeView(), PopularView(), FavoriteView()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: pageIndex, children: viewRoutes),
      bottomNavigationBar: CustomBottomNavigationbar(currentIndex: pageIndex),
    );
  }
}



import 'package:flutter/material.dart';



class PopularView extends StatelessWidget {
  const PopularView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Popular Movies'),
      ),
      body: Center(
        child: Text('Popular View'),
      ),
    );
  }
}
import 'package:flutter/material.dart';

class FullScreenLoader extends StatelessWidget {
  const FullScreenLoader({super.key});

  Stream<String> getLoadMessage() {
    final message = <String>[
      'Cargando...',
      'Por favor espera...',
      'Estamos preparando todo para ti...',
    ];

    return Stream.periodic(Duration(milliseconds: 500), (step) {
      return message[step];
    }).take(message.length);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          CircularProgressIndicator(),
          StreamBuilder(
            stream: getLoadMessage(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Text('Cargando.......');
              }
              return Text(snapshot.data!);
            },
          ),
        ],
      ),
    );
  }
}

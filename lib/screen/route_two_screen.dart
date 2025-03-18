import 'package:flutter/material.dart';
import 'package:flutter_study/layout/default_layout.dart';

class RouteTwoScreen extends StatelessWidget {
  const RouteTwoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments;

    return DefaultLayout(
      title: 'RouteTwoScreen',
      children: [
        Text('$arguments'),
        OutlinedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('PoP'),
        ),
        OutlinedButton(
          onPressed: () {
            Navigator.of(context).pushNamed('/three', arguments: 777);
          },
          child: Text('Push RouteThreeScreen'),
        ),
        OutlinedButton(
          onPressed: () {
            Navigator.of(context)
                .pushReplacementNamed('/three', arguments: 777);
          },
          child: Text('Push RouteThreeScreen Replacement'),
        ),
        OutlinedButton(
          onPressed: () {
            Navigator.of(context).pushNamedAndRemoveUntil(
              '/three',
              (route) {
                return route.settings.name == '/';
              },
            );
          },
          child: Text('Push RouteThreeScreen RemoveUntil'),
        )
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_study/layout/default_layout.dart';

class RouteThreeScreen extends StatelessWidget {
  const RouteThreeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments;

    return DefaultLayout(
      title: 'RouteThreeScreen',
      children: [
        Text('$arguments'),
        // 나를 없애시오
        OutlinedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Pop')),
        // 화면 추가
        OutlinedButton(
          onPressed: () {
            Navigator.of(context).pushNamed('/two');
          },
          child: Text('Push RouteTwoScreen'),
        )
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_study/layout/default_layout.dart';
import 'package:flutter_study/screen/route_one_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: 'HomeScreen',
      children: [
        OutlinedButton(
          onPressed: () async {
            final result = await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return RouteOneScreen(
                    number: 20,
                  );
                },
              ),
            );
            // print(result);
          },
          child: Text('Push'),
        ),
      ],
    );
  }
}

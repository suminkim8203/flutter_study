import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool show = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (show) CodeFactoryWidget(),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  show = !show;
                });
              },
              child: Text('!!클릭!!'),
            )
          ],
        ),
      ),
    );
  }
}

class CodeFactoryWidget extends StatefulWidget {
  CodeFactoryWidget({super.key}) {
    print('1) Stateful Widget Constructor');
  }

  @override
  State<CodeFactoryWidget> createState() {
    print('2) Stateful Widget Create State');

    return _CodeFactoryWidgetState();
  }
}

class _CodeFactoryWidgetState extends State<CodeFactoryWidget> {
  @override
  void initState() {
    print('3) Stateful Widget initState');
    super.initState();
  }

  @override
  void didChangeDependencies() {
    print('4) Stateful Widget didChangeDependencies');
    super.didChangeDependencies();
  }

  Widget build(BuildContext context) {
    print('5) Stateful Widget build');
    return Container(
      color: Colors.red,
      width: 50.0,
      height: 50.0,
    );
  }

  @override
  void deactivate() {
    print('6) Stateful Widget deactivate');
    // TODO: implement deactivate
    super.deactivate();
  }

  @override
  void dispose() {
    print('7) Stateful Widget dispose');
    // TODO: implement dispose
    super.dispose();
  }
}

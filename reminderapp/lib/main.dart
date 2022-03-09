import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Reminder App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //int _counter = 0;

  void _incrementCounter() {
    setState(() {
      //_counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Material(
          color: const Color.fromARGB(255, 63, 138, 168),
          child: ListView(
            children: [
              const SizedBox(height: 40),
              buildMenuItem(
                text: 'Work Task',
                icon: Icons.access_alarm,
                onClicked: () => selectedItem(context, 0),
              ),
              const SizedBox(height: 40),
              buildMenuItem(
                text: 'Personal Task',
                icon: Icons.access_alarm,
                onClicked: () => selectedItem(context, 0),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget buildMenuItem({
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
  }) {
    const color = Colors.white;
    return ListTile(
      leading: Icon(
        icon,
        color: color,
      ),
      title: Text(text, style: const TextStyle(color: color)),
      onTap: onClicked,
    );
  }

  void selectedItem(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const WorkReminder(),
        ));
        break;
    }
  }
}

class WorkReminder extends StatelessWidget {
  const WorkReminder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Work Task'),
        ),
      );
}



/*class PageTwo extends _MyHomePageState {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Burger Time!'),
      ),
      body: const Center(
        child: Text('Page TWO /flex'),
      ),
     // drawer: MyDrawerDirectory(), // ← Drawer Directory a.k.a. burger icon
    );
  }
}*/


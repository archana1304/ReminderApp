import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reminder Alert',
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
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  String inputDate = "";
  //List<TextEditingController> _controllers = new List.generate(int, (index) => null)
  List<TextEditingController> _controllers = [];

  final TextEditingController _textFieldController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Add Reminder'),
            content: TextField(
              controller: _textFieldController,
              onChanged: (value) {
                setState(() {
                  valueText = _textFieldController.text;
                });
              },
              decoration: const InputDecoration(hintText: "Reminder"),
            ),
            actions: <Widget>[
              ElevatedButton(
                child: const Text('CANCEL'),
                style: ElevatedButton.styleFrom(
                  onPrimary: Colors.white,
                  primary: Colors.red,
                ),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              ElevatedButton(
                child: const Text('OK'),
                style: ElevatedButton.styleFrom(
                  onPrimary: Colors.white,
                  primary: Colors.green,
                ),
                onPressed: () {
                  setState(() {
                    codeDialog = valueText;
                    Navigator.pop(context);
                    //vents
                  });
                },
              ),
              ElevatedButton(
                child: const Icon(Icons.event),
                style: ElevatedButton.styleFrom(
                  onPrimary: Colors.white,
                  primary: const Color.fromARGB(255, 63, 99, 129),
                ),
                onPressed: () {
                  _selectDate(context);
                },
              ),
              ElevatedButton(
                child: const Icon(Icons.timer),
                style: ElevatedButton.styleFrom(
                  onPrimary: Colors.white,
                  primary: const Color.fromARGB(255, 125, 165, 72),
                ),
                onPressed: () {
                  _selectTime(context);
                },
              ),
            ],
          );
        });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2021, 3),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _dateController.text = DateFormat.yMd().format(selectedDate);
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay != null && timeOfDay != selectedTime) {
      setState(() {
        selectedTime = timeOfDay;
        inputDate = selectedTime.format(context);
      });
    }
  }

  String? codeDialog;
  String? valueText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(backgroundColor: Colors.teal, title: const Text('Reminder')),
      body: Center(
        child: Material(
          color: const Color.fromARGB(255, 63, 138, 168),
          // child: ListView(
          //   children: [
          //     const SizedBox(height: 40),
          //     buildMenuItem(
          //       text: _textFieldController.text,
          //       icon: Icons.access_alarm,
          //       onClicked: () => selectedItem(context, 0),
          //       time: inputDate,
          //       date: _dateController.text,
          //     ),
          //     // const SizedBox(height: 40),
          //     // buildMenuItem(
          //     //   text: 'Personal Task',
          //     //   icon: Icons.access_alarm,
          //     //   onClicked: () => selectedItem(context, 0),
          //     // ),
          //   ],
          // ),
          child:
              ListView.builder(itemBuilder: (BuildContext context, int index) {
            _controllers.add(_textFieldController);
            return Container(
              child: buildMenuItem(
                text: _controllers[index].text,
                icon: Icons.access_alarm,
                onClicked: () {
                  selectedItem(context, index);
                  _textFieldController.dispose();
                }, //() => selectedItem(context, 0),
                time: inputDate,
                date: _dateController.text,
              ),
            );
          }),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _displayTextInputDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget buildMenuItem({
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
    required String date,
    required String time,
  }) {
    const color = Colors.white;
    return ListTile(
      leading: Icon(
        icon,
        color: color,
      ),
      title: Text(text, style: const TextStyle(color: color)),
      subtitle: Text(time, style: const TextStyle(color: color)),
      trailing: Text(date, style: const TextStyle(color: color)),
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

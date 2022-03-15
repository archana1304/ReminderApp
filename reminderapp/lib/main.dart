import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reminderapp/model/reminder_info.dart';
import 'package:reminderapp/reminder_helper.dart';

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
  List<String> _reminder = [];
  List<String> _date = [];
  List<String> _time = [];
  final TextEditingController _textFieldController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  ReminderHelper _reminderHelper = ReminderHelper();
  Future<List<ReminderInfo>>? _reminders ;

  void initState(){
      
    _reminderHelper.intializeDatabase().then((value)=> {
      print('--------Datebase Intialized--------'),
      _reminders = _reminderHelper.getReminders()
    });

    super.initState();
  }
  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Add Reminder'),
            content: TextField(
              controller: _textFieldController,
              onSubmitted: (text) {},
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
                    // valueText = _textFieldController.text;
                    _reminder.add(_textFieldController.text);
                    // _textFieldController.clear();
                    // _date.add(_dateController.text);
                    // _time.add(inputDate);
                    Navigator.pop(context);
                    
                    var reminderInfo = ReminderInfo(
                      title: _textFieldController.text,
                      reminderDate: selectedDate,
                      reminderTime:  selectedTime,
                    );
                   // _reminderHelper.insertReminder(reminderInfo);

                    
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
      body: Column(children: <Widget>[
        Expanded(
          child: FutureBuilder(
            future: _reminderHelper.getReminders(),
            builder: (context, snapshot) {
            if(snapshot.hasData) {
              //_currentReminders = snapshot.data;
              return ListView.builder(
              itemCount: _reminder.length,
              itemBuilder: (BuildContext context, int index) {
                return buildMenuItem(
                  text: _textFieldController.text,
                  icon: Icons.access_alarm,
                  // onClicked: () {
                  //   selectedItem(context, index);
                  // },
                  time: _time[index],
                  date: _date[index],
                );
              });
            }
              return const Center(
                child: Text(
                  'loading',
                ),
              );
          })
          ,
        ),
      ]),
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
    const color = Colors.black;
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

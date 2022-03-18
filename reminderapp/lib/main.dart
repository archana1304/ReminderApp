import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:intl/intl.dart';

import 'package:reminderapp/model/reminder_info.dart';
import 'package:reminderapp/notifications_helper.dart';
import 'package:reminderapp/reminder_helper.dart';
import 'package:rxdart/rxdart.dart';

bool hasInit = false;

final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotification>();

final BehaviorSubject<String?> selectNotificationSubject =
    BehaviorSubject<String?>();

class ReceivedNotification {
  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });

  final int id;
  final String? title;
  final String? body;
  final String? payload;
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  _notificationClass.initNotifications().then((value) => {hasInit = true});
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

NotificationClass _notificationClass = NotificationClass();

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
  static const TimeOfDay defaultTime = TimeOfDay(hour: 12, minute: 30);

  //NotificationClass _notificationClass = NotificationClass();

  ReminderHelper _reminderHelper = ReminderHelper();
  bool isDirty = true;

  void initState() {
    _reminderHelper.intializeDatabase().then((value) => {
          print('--------Datebase Intialized--------'),
          _reminderHelper.getReminders(isDirty)
        });
    super.initState();
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    Dialog fancyDialog = Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
        ),
        height: 300.0,
        width: 300.0,
        child: Stack(
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 300,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(1.0, 2.0, 1.0, 2.0),
              width: double.infinity,
              height: 50,
              alignment: Alignment.bottomCenter,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 138, 102, 221),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  "Add Reminder",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
            Align(
              alignment: Alignment(0.5, -0.5),
              child: TextField(
              controller: _textFieldController,
              onSubmitted: (text) {},
              decoration: const InputDecoration(hintText: "Reminder",contentPadding: EdgeInsets.all(20)),
            ),
            ),
            Align(
              alignment: Alignment(-0.4,0.2),
              child: ElevatedButton(
                child: const Icon(Icons.event),
                style: ElevatedButton.styleFrom(
                  onPrimary: Colors.white,
                  primary: const Color.fromARGB(255, 63, 99, 129),
                ),
                onPressed: () {
                  _selectDate(context);
                },
              ),
            ),
            Align(
              alignment: Alignment(0.6,0.2),
              child: ElevatedButton(
                child: const Icon(Icons.timer),
                style: ElevatedButton.styleFrom(
                  onPrimary: Colors.white,
                  primary: const Color.fromARGB(255, 63, 99, 129),
                ),
                onPressed: () {
                  _selectTime(context);
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: InkWell(
                onTap: () {
                  setState(() {
                    _reminder.add(_textFieldController.text);
                    Navigator.pop(context);

                    var reminderInfo = ReminderInfo(
                      title: _textFieldController.text,
                      reminderDate: selectedDate,
                      reminderTime: selectedTime,
                    );
                    _reminderHelper.insertReminder(reminderInfo).then((value) =>
                        {_notificationClass.scheduleNotifications(value)});
                    isDirty;
                    _textFieldController.clear();
                  });
                },
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 40, 134, 32),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "save",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
            ),
            Align(
              // These values are based on trial & error method
              alignment: Alignment(1.05, -1.05),
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 155, 49, 49),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.close,
                    color: Color.fromARGB(255, 219, 209, 209),
                  ),
                  
                ),
              ),
            ),
          ],
        ),
      ),
    );
    showDialog(
        context: context, builder: (BuildContext context) => fancyDialog);
  }
  /*Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Add Reminder'),
            // actions: <Widget>[
            // ElevatedButton(
            //   onPressed:()=> Navigator.pop(context,true) , 
            //   child: Icon (Icons.close)),
            // ]
            content: TextField(
              controller: _textFieldController,
              onSubmitted: (text) {},
              decoration: const InputDecoration(hintText: "Reminder"),
            ),
            actions: <Widget>[
              // ElevatedButton(
              //   child: const Text('CANCEL'),
              //   style: ElevatedButton.styleFrom(
              //     onPrimary: Colors.white,
              //     primary: Colors.red,
              //   ),
              //   onPressed: () {
              //     setState(() {
              //       Navigator.pop(context);
              //     });
              //   },
              // ),
              ElevatedButton(
                child: const Text('OK'),
                style: ElevatedButton.styleFrom(
                  onPrimary: Colors.white,
                  primary: Colors.green,
                ),
                onPressed: () {
                  setState(() {
                    _reminder.add(_textFieldController.text);
                    Navigator.pop(context);

                    var reminderInfo = ReminderInfo(
                      title: _textFieldController.text,
                      reminderDate: selectedDate,
                      reminderTime: selectedTime,
                    );
                    _reminderHelper.insertReminder(reminderInfo).then((value) =>
                        {_notificationClass.scheduleNotifications(value)});
                    isDirty;
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
  }*/

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
              future: _reminderHelper.getReminders(isDirty),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<ReminderInfo> rem = snapshot.data as List<ReminderInfo>;
                  return ListView.builder(
                      itemCount: rem.length,
                      itemBuilder: (BuildContext context, int index) {
                        return buildMenuItem(
                          text: rem[index].title ?? "Reminder",
                          icon: Icons.access_alarm,
                          OnLongPress: () {
                            setState(() {
                              rem.remove(index);
                              _reminderHelper.delete(rem[index].id ?? 0);
                            });
                          },
                          time: (rem[index].reminderTime ?? defaultTime)
                              .format(context),
                          date: DateFormat.yMd().format(
                              rem[index].reminderDate ?? DateTime.now()),
                        );
                      });
                }
                return const Center(
                  child: Text(
                    'loading',
                  ),
                );
              }),
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
    VoidCallback? OnLongPress,
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
      onLongPress: OnLongPress,
    );
  }

  // void selectedItem(BuildContext context, int index) {
  //   switch (index) {
  //     case 0:
  //       Navigator.of(context).push(MaterialPageRoute(
  //         builder: (context) => const WorkReminder(),
  //       ));
  //       break;
  //   }
  // }
}

// class WorkReminder extends StatelessWidget {
//   const WorkReminder({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) => Scaffold(
//         appBar: AppBar(
//           title: const Text('Work Task'),
//         ),
//       );
// }

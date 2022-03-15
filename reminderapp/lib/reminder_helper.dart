import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:reminderapp/model/reminder_info.dart';

const String tableReminder = 'reminder';
const String columnId = 'id';
const String columnTitle = 'title';
const String columnDate = 'reminderDate';
const String columnTime = 'reminderTime';
const String columnPending = 'isPending';
//final String columnColorIndex = 'gradientColorIndex';

class ReminderHelper {
  late Database _database;
  bool hasInitDB = false;
  //late ReminderHelper _reminderHelper;

 // ReminderHelper._createInstance();
  // factory ReminderHelper() {
  //   if (_reminderHelper == null) {
  //     _reminderHelper = ReminderHelper._createInstance();
  //   }
  //   return _reminderHelper;
  // }

  Future<Database> get database async {
    if (!hasInitDB) {
      _database = await intializeDatabase();
      hasInitDB = true;
    }
    return _database;
  }

  Future<Database> intializeDatabase() async {
    var dir = await getDatabasesPath();
    var path = dir + "reminder.db";

    var database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
        create table $tableReminder ( 
          $columnId integer primary key autoincrement, 
          $columnTitle text not null,
          $columnDate text not null,
          $columnTime text not null,
          $columnPending integer,)
        ''');
      },
    );
    return database;
  }
// insert the data into the database
  Future<void> insertReminder(ReminderInfo reminderInfo) async {
    var db = await database;
    var result = await db.insert(tableReminder, reminderInfo.toMap());
    print('result : $result');
  }

  //fetch the data and return it
  Future<List<ReminderInfo>> getReminders() async {
    List<ReminderInfo> _reminders = [];

    var db = await this.database;
    var result = await db.query(tableReminder);
    result.forEach((element) {
      var reminderInfo = ReminderInfo.fromMap(element);
      _reminders.add(reminderInfo);
    });

    return _reminders;
  }

  Future<int> delete(int id) async {
    var db = await this.database;
    return await db.delete(tableReminder, where: '$columnId = ?', whereArgs: [id]);
  }
}

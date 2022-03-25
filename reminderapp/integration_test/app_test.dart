import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reminderapp/main.dart' as app;

void main() {
  testWidgets('POC', (WidgetTester tester) async {
    app.main();

    await tester.pump();
    final addBtn = find.byKey(const ValueKey('addBtn'));
    await tester.tap(addBtn);

    await tester.pump();
    final reminderTextField = find.byKey(const ValueKey('inputText'));

    await tester.pump();
    await tester.enterText(reminderTextField, "test1");
    expect(find.text('test1'), findsOneWidget);

    final selectTime = find.byKey(const Key('inputTime'));
    await tester.tap(selectTime);

    //var text = find.text('OK', findRichText: true);
    //final okBtn =
    //find.descendant(of: find.byType(TextButton), matching: find.text(text));
    //await tester.tap(okBtn);

    //await tester.tap(text);
    await tester.pump();
    final okBtn = find.descendant(
        of: find.byType(TextButton), matching: find.textContaining('OK'));
    await tester.ensureVisible(okBtn);
    await tester.tap(okBtn);

    final selectDate = find.byKey(const ValueKey('inputDate'));
    await tester.pump();
    await tester.tap(selectDate);

    await tester.pump();
    await tester.tap(okBtn);

    await tester.pump();
    final saveBtn = find.byKey(const ValueKey('SaveBtn'));
    await tester.ensureVisible(saveBtn);
    await tester.tap(saveBtn);

    await tester.pump();
    final listOfReminder = find.descendant(
        of: find.byType(List),
        matching: find.byKey(const ValueKey('listReminder')));

    expect(listOfReminder, findsOneWidget);
  });
}

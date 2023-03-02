import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

import 'notifications.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab4_193087',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Lab4'),
    );
  }
}

class ExamDate {
  late String name;
  late DateTime date;
  late String time;
  late String user;

  ExamDate(this.name, this.date, this.time, this.user);
}

List<ExamDate> examDates = [
  ExamDate('Object Oriented Programming', DateTime(2022, 12, 14), '10 AM', 'Dimitarcho'),
  ExamDate('Business Statistics', DateTime(2022, 12, 21), '11 AM', 'Dimitarcho'),
];

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var textEditingController = TextEditingController();
  String _name = "";
  DateTime _date = DateTime.now();
  TimeOfDay _time =
  TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute);
  bool _dateSelected = false;
  bool _timeSelected = false;
  bool loggedIn = false;
  var emailController = TextEditingController();
  var passController = TextEditingController();
  CalendarFormat format = CalendarFormat.month;
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();
  TextEditingController _eventController = TextEditingController();
  var email;

  final termsArray = [
    {"name": 'Object Oriented Programming', "date": 'Nov 10, 2022', "time": '10:00 AM'},
    {"name": 'Business Statistics', "date": '25 Nov, 2022', "time": '02:00 PM'},
  ];

  @override
  void initState() {
    checkLogin().then((value) {});
    super.initState();
  }

  void add() {
    if (_name != "") {
      NotificationService().show(1, "Exam", "Added new exam date", 2);
      examDates.add(
        ExamDate(_name, _date, _time.format(context), email),
      );
    }
    setState(() {
      termsArray.add({
        "name": _name,
        "date": DateFormat.yMMMd().format(_date),
        "time": _time.format(context)
      });
    });
    textEditingController.clear();
    _dateSelected = false;
    _timeSelected = false;
  }

  Future checkLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    email = prefs.getString("email");
    var password = prefs.getString("password");

    if (email != null && password != null) {
      loggedIn = true;
    } else {
      loggedIn = false;
    }
  }

  List<ExamDate> getExams(DateTime date) {
    return examDates.where((element) => element.date.day == date.day).toList() ?? [];
  }

  @override
  void dispose() {
    _eventController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 4 - 193087',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Lab4_193087'),
          actions: loggedIn ? <Widget>[
            ElevatedButton(
                child: Text('ADD'),
                onPressed: add,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.green),
                )
            ),
            ElevatedButton(
                child: Text('Logout'),
                onPressed: () async {
                  SharedPreferences preferences = await SharedPreferences.getInstance();

                  preferences.remove('email');
                  preferences.remove('password');

                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (_) {
                        return MyHomePage(title: "Lab4");
                      }));
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.redAccent),
                )
            ),
          ] : <Widget>[Text("")],
        ),
        body: !loggedIn ? Login() : SingleChildScrollView( child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
              child: TextField(
                controller: textEditingController,
                onChanged: (text) {
                  setState(() {
                    _name = text;
                  });
                },
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Enter subject',
                ),
              ),
            ),
            Text(_dateSelected ? DateFormat.yMMMd().format(_date) : 'Pick date'),
            ElevatedButton(
              child: Text(!_dateSelected ? 'Select a date' : 'Change date'),
              onPressed: () async {
                showDatePicker(
                    context: context,
                    initialDate: _date == null ? DateTime.now() : _date,
                    firstDate: DateTime(2022),
                    lastDate: DateTime(2023))
                    .then((date) {
                  setState(() {
                    _date = date!;
                    _dateSelected = true;
                  });
                });
              },
            ),
            Text(_timeSelected ? _time.format(context) : 'Pick time'),
            ElevatedButton(
              child: Text(!_timeSelected ? 'Select time' : 'Change Time'),
              onPressed: () async {
                showTimePicker(
                    context: context,
                    initialTime:
                    TimeOfDay(hour: _date.hour, minute: _date.minute))
                    .then((time) {
                  setState(() {
                    _time = time!;
                    _timeSelected = true;
                  });
                });
                ;
              },
            ),
            TableCalendar(
              focusedDay: selectedDay,
              firstDay: DateTime(2000),
              lastDay: DateTime(2050),
              calendarFormat: format,
              onFormatChanged: (CalendarFormat _format) {
                setState(() {
                  format = _format;
                });
              },
              startingDayOfWeek: StartingDayOfWeek.monday,
              daysOfWeekVisible: true,

              //Day Changed
              onDaySelected: (DateTime selectDay, DateTime focusDay) {
                if (!isSameDay(selectedDay, selectDay)) {
                  setState(() {
                    selectedDay = selectDay;
                    focusedDay = focusDay;
                  });
                }
              },

              selectedDayPredicate: (DateTime date) {
                return isSameDay(selectedDay, date);
              },

              eventLoader: (day) {
                return getExams(day);
              },

              //To style the Calendar
              calendarStyle: CalendarStyle(
                isTodayHighlighted: true,
                selectedDecoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(5.0),
                ),

                selectedTextStyle: TextStyle(color: Colors.white),
                todayDecoration: BoxDecoration(
                  color: Colors.redAccent,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(5.0),
                ),

                defaultDecoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(5.0),
                ),

                weekendDecoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),

              headerStyle: HeaderStyle(
                formatButtonVisible: true,
                titleCentered: true,
                formatButtonDecoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                formatButtonTextStyle: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            ...getExams(selectedDay).map(
                  (ExamDate exam) => Card(
                child: ListTile(
                  title: Text(
                    "User: " + exam.user + " \n" + exam.name,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '${DateFormat.yMMMd().format(exam.date)} - ${exam.time}',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }


}

class Login extends StatelessWidget {
  var email = "";
  var password = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: TextField(
            onChanged: (text) {
              email = text;
            },
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Email',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: TextField(
            obscureText: true,
            onChanged: (text) {
              password = text;
            },
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Password',
            ),
          ),
        ),
        ElevatedButton(
            child: Text('Login'),
            onPressed: () async {
              if (email.toString() != "" && password.toString() != "") {
                SharedPreferences preferences = await SharedPreferences.getInstance();

                preferences.setString("email", email);
                preferences.setString("password", password);

                NotificationService().show(1, "New Login", "Logged In", 2);
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) {
                      return MyHomePage(title: "");
                    }));
              }
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.blue),
            )),
      ]),
    );
  }
}

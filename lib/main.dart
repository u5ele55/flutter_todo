import 'package:flutter/material.dart';
import 'package:todo/globals.dart';
import 'package:todo/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dbHandler.initDatabase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TODO app by u5ele55',
      theme: ThemeData(
          primarySwatch: Colors.amber,
          primaryColor: Colors.deepOrange,
          backgroundColor: Colors.amber[100],
          splashColor: Colors.amber[200],
          appBarTheme: const AppBarTheme(
              iconTheme: IconThemeData(color: Colors.white, size: 28),
              titleTextStyle: TextStyle(color: Colors.white, fontSize: 24))),
      home: const HomePage(),
    );
  }
}

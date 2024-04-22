import 'package:flutter/material.dart';
import 'package:localisation/screen/home_screen.dart';

class App extends StatelessWidget {
  // Add a named 'key' parameter to the constructor
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      key: UniqueKey(), // Add a unique key
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(key: UniqueKey()), // Provide a unique key for HomeScreen
    );
  }
}

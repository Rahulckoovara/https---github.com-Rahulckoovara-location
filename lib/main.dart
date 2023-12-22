import 'package:flutter/material.dart';
import 'package:location/LocationScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main(){
  runApp(MyApp()
  );
  initializeApp();
}
Future<void> initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Perform asynchronous operations here, such as initializing variables
  // You can use 'await' here
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // ... other initialization logic

 
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:LoacationScreen()
    );

  }
}
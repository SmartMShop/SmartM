import 'package:ar_smart_wear/Screens/BodyMeasurementsScreen.dart';
import 'package:ar_smart_wear/Screens/CameraScreen.dart';
import 'package:ar_smart_wear/Screens/GenderScreen.dart';
import 'package:ar_smart_wear/Screens/HomeScreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: HomeScreen.id,
      routes: {
        HomeScreen.id: (context) => HomeScreen(),
        GenderScreen.id: (context) => GenderScreen(),
        CameraScreen.id: (context) => CameraScreen(),
        BodyMeasurements.id: (context) => BodyMeasurements(),
      },
    );
  }
}

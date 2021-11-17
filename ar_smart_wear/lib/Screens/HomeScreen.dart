import 'package:ar_smart_wear/Screens/GenderScreen.dart';
import 'package:ar_smart_wear/Widgets/CustButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  static const id = "HomeScreen";
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/Images/homePageBackground.jpeg"),
                  fit: BoxFit.cover),
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    // Colors.blue,
                    Colors.white,
                    Colors.white,
                    // Colors.yellow,
                    // Colors.greenAccent,
                  ])),
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: screenSize.height / 1.5,
                ),
                CustButton(
                  screenSize: screenSize,
                  textColor: Colors.white,
                  borderColor: Colors.purple,
                  fillColor: Colors.purple,
                  text: "Start",
                  onTap: () {
                    Navigator.pushNamed(context, GenderScreen.id);
                  },
                ),
              ],
            ),
          )),
    );
  }
}

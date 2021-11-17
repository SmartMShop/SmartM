import 'package:ar_smart_wear/Screens/CameraScreen.dart';
import 'package:ar_smart_wear/Widgets/CustButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GenderScreen extends StatefulWidget {
  static const id = "GenderScreen";
  @override
  _GenderScreenState createState() => _GenderScreenState();
}

class _GenderScreenState extends State<GenderScreen> {
  bool man = true;
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/Images/background.jpeg"),
                fit: BoxFit.cover),
          ),
          child: Column(
            children: [
              Text(
                "Choose Your Gender",
                style: GoogleFonts.gloriaHallelujah(
                    fontSize: screenSize.width / 10,
                    color: Colors.purple,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: screenSize.height / 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustButton(
                    screenSize: screenSize,
                    textColor: Colors.white,
                    borderColor: Colors.purple,
                    fillColor: Colors.purple,
                    heightDiv: screenSize.width / 36,
                    widthDiv: screenSize.width / 130,
                    text: "Man",
                    onTap: () {
                      setState(() {
                        man = true;
                      });
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CameraScreen(
                                    man: man,
                                  )));
                    },
                  ),
                  SizedBox(
                    width: screenSize.width / 20,
                  ),
                  CustButton(
                    screenSize: screenSize,
                    textColor: Colors.white,
                    borderColor: Colors.purple,
                    fillColor: Colors.purple,
                    heightDiv: screenSize.width / 36,
                    widthDiv: screenSize.width / 130,
                    text: "Woman",
                    onTap: () {
                      setState(() {
                        man = false;
                      });
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CameraScreen(
                                    man: man,
                                  )));
                    },
                  ),
                ],
              ),
              SizedBox(
                height: screenSize.height / 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: screenSize.height / 2,
                    width: screenSize.width / 3,
                    child: Image.asset("assets/Images/man.png"),
                  ),
                  SizedBox(
                    width: screenSize.width / 6,
                  ),
                  Container(
                    height: screenSize.height / 2,
                    width: screenSize.width / 3,
                    child: Image.asset("assets/Images/woman.png"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

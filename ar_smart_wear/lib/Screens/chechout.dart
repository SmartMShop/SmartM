import 'package:ar_smart_wear/Widgets/CustButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CheckOutScreen extends StatefulWidget {
  @override
  _CheckOutScreenState createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Check Out",
          style: GoogleFonts.gloriaHallelujah(fontSize: screenSize.width / 12),
        ),
        backgroundColor: Colors.purple,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/Images/background.jpeg"),
              fit: BoxFit.cover),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustButton(
                screenSize: screenSize,
                textColor: Colors.white,
                borderColor: Colors.purple,
                fillColor: Colors.purple,
                heightDiv: screenSize.width / 36,
                widthDiv: screenSize.width / 130,
                text: "Edit",
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              Text(
                "Total Amount",
                style: GoogleFonts.gloriaHallelujah(
                    fontSize: screenSize.width / 13,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                "100 AED",
                style: GoogleFonts.gloriaHallelujah(
                    fontSize: screenSize.width / 13,
                    color: Colors.blue[900],
                    fontWeight: FontWeight.bold),
              ),
              Text(
                "Done!",
                style: GoogleFonts.gloriaHallelujah(
                    fontSize: screenSize.width / 16),
              ),
              Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                    color: Colors.transparent.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(100)),
                child: Icon(
                  Icons.check_rounded,
                  size: screenSize.width / 3,
                  color: Colors.white,
                ),
              ),
              Text("Order No: 234211"),
              SizedBox(
                height: screenSize.height / 6,
              )
            ],
          ),
        ),
      ),
    );
  }
}

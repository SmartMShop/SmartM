import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NumBelowText extends StatelessWidget {
  const NumBelowText({
    Key key,
    @required this.screenSize,
    @required this.height,
    this.text,
  }) : super(key: key);

  final Size screenSize;
  final double height;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          text,
          style: GoogleFonts.gloriaHallelujah(
              fontSize: screenSize.width / 13,
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
        Text(
          "$height",
          style: GoogleFonts.gloriaHallelujah(
              fontSize: screenSize.width / 13,
              color: Colors.white,
              fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}
